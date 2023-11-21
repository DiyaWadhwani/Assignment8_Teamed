//
//  NewMessageFirebaseManager.swift
//  WA8_14
//
//  Created by Diya on 11/17/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import CryptoKit

extension NewMessageViewController {
    
    
    func fetchUsersFromFirebase() {
        print("all users")
        //set list of names to userList
        
        let userCollection = database.collection("users").getDocuments() { (querySnapshot, error) in
            if error == nil {
                let users = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: User.self)
                } ?? []
                //                print("All users fetched -- \(users)")
                self.userList = users
                
                if let currentUserDisplayName = self.currentUser?.displayName {
                    self.userList = self.userList.filter { $0.name != currentUserDisplayName }
                }
                
                //                print("UserList after removing the logged in user -- \(self.userList)")
                
                for user in self.userList {
                    self.userNames.append(user.name)
                }
                print("List of names -- \(self.userNames)")
                //                self.newMessageView.pickerView.reloadAllComponents()
            }
        }
    }
    
    func sendChatToUser(_ toUsername: String, _ message: String){
        
        print("sending chat to user")
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let dateString = dateFormatter.string(from: currentDate)
        
        var chatUUID: String = ""
        
        let chatCollection = database.collection("chats")
        
        print("Current User -- \(self.currentUser)")
        
        if let fromUser = self.currentUser {
            if let email1 = fromUser.email {
                for contact in userList {
                    if toUsername == contact.name {
                        var email2 = contact.email
                        
                        var emailList = [String]()
                        emailList.append(email1)
                        emailList.append(email2)
                        
                        chatUUID = generateUUID(emailList)
                        
                        var chatObject = Chat(timestamp: dateString, message: message, toUser: email2, fromUser: email1)
                        
                        let messageCollection = chatCollection.document(chatUUID).collection("messages")
                        var messageCollectionCount: Int = 0
                        messageCollection.getDocuments(completion: { (querySnapshot, error) in
                            if let error = error {
                                print("Failed to fetch messageCollection documents: \(error.localizedDescription.description)")
                            }
                            else{
                                messageCollectionCount = querySnapshot?.documents.count ?? 0
                                print("No. of documents in messages collection: \(messageCollectionCount)")
                                
                                let newMessageDocName = "message\(messageCollectionCount)"
                                messageCollection.document(newMessageDocName).setData(chatObject.asDictionary) { error in
                                    if let error = error {
                                        print("Failed to create new message document: \(error.localizedDescription.description)")
                                    }
                                    else {
                                        print("New document added succesfully")
                                        var usersInConversation = [String]()
                                        usersInConversation.append(fromUser.displayName!)
                                        usersInConversation.append(toUsername)
                                        self.addChatReferenceIDToUsers(chatUUID, emailList, usersInConversation)
                                    }
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    func addChatReferenceIDToUsers(_ chatUUID: String, _ emails: [String], _ usersInConversation: [String]) {
        
        let userCollection = database.collection("users")
        var user1Collection = userCollection.document(emails[0])
        var user2Collection = userCollection.document(emails[1])
        
        user1Collection.getDocument{ (user1DocSnapshot, error) in
            if let error = error {
                print("Error fetching user1 document: \(error.localizedDescription)")
            } else {
                if let user1Data = user1DocSnapshot?.data(),
                   let chatsCollection1 = user1Data["chats"] as? [String: Any],
                   let chatRefDocument1 = chatsCollection1["chatRef"] as? [String: Any] {
                    print("User1 has the 'chats' collection with 'chatRef' document.")
                } else {
                    print("User1 does not have the 'chats' collection with 'chatRef' document.")
                    self.addChatRefDocument(to: user1Collection.collection("chats"), chatUUID, emails[1], usersInConversation[1])
                }
            }
        }
        
        user2Collection.getDocument{ (user2DocSnapshot, error) in
            if let error = error {
                print("Error fetching user2 document: \(error.localizedDescription)")
            } else {
                if let user2Data = user2DocSnapshot?.data(),
                   let chatsCollection2 = user2Data["chats"] as? [String: Any],
                   let chatRefDocument2 = chatsCollection2["chatRef"] as? [String: Any] {
                    print("User2 has the 'chats' collection with 'chatRef' document.")
                } else {
                    print("User2 does not have the 'chats' collection with 'chatRef' document.")
                    self.addChatRefDocument(to: user2Collection.collection("chats"), chatUUID, emails[0], usersInConversation[0])
                }
            }
        }
    }
    
    func addChatRefDocument(to chatCollection: CollectionReference, _ chatUUID: String, _ email: String, _ userName: String) {
        let chatRefDocumentData = [
            // Add any fields you want in the "chatRef" document
            "userNameInConversation": userName,
            "userEmailInConversation": email
        ]
        
        // Add the "chatRef" document to the "chats" collection
        let newDocument = chatCollection.document(chatUUID)
        newDocument.setData(chatRefDocumentData) { error in
            if let error = error {
                print("Error adding 'chatRef' document: \(error.localizedDescription)")
            } else {
                print("Added 'chatRef' document successfully.")
                self.newMessageView.recipientTextField.isEnabled = false
                self.newMessageView.recipientDropDownTable.isHidden = true
                self.newMessageView.messageTextField.text = ""
            }
        }
    }
    
    func loadChatsOnUserViewScreen(_ chatUUID: String) {
        
        
        print("CurrentChatList -- \(self.chatList)")
        
        var hasNewMessage = false
        
        let chatsCollection = database.collection("chats")
        let messageCollection = chatsCollection.document(chatUUID).collection("messages")
        
        var query = messageCollection.order(by: "timestamp", descending: false)
        
        if let lastSnapshot = lastDocumentSnapshot {
            query = query.start(afterDocument: lastSnapshot)
        }
        
        query.addSnapshotListener(includeMetadataChanges: false, listener: { (querySnapshot, error) in
            
            if error == nil {
                if let querySnapshot = querySnapshot{
                    print("fetched documents in messagecollection")
                    
                    for doc in querySnapshot.documents {
                        
                        let data = doc.data()
                        print("data in doc -- \(data)")
                        if let timestamp = data["timestamp"] as? String,
                           let messageText = data["message"] as? String,
                           let fromUser = data["fromUser"] as? String,
                           let toUser = data["toUser"] as? String {
                            
                            let chat = Chat(timestamp: timestamp, message: messageText, toUser: toUser, fromUser: fromUser)
                            
                            print("Message recieved -- \(chat)")
                            
                            if self.chatList.firstIndex(where: { $0.timestamp == chat.timestamp && $0.message == chat.message && $0.toUser == chat.toUser && $0.fromUser == chat.fromUser }) == nil {
                                self.chatList.append(chat)
                                hasNewMessage = true
                            }
                            
                            //                            print("CurrentChatList -- \(self.chatList)")
                        }
                        else{
                            print("Failed to fetch data from doc")
                        }
                        
                        //                    dispatchGroup.leave()
                        //                    processedDocs += 1
                    }
                    
                    if let lastDocument = querySnapshot.documents.last {
                        self.lastDocumentSnapshot = lastDocument
                    }
                    
                    if hasNewMessage {
                        //                dispatchGroup.notify(queue: .main){
                        DispatchQueue.main.async {
                            //                    self.newMessageView.layoutIfNeeded()
                            //                        self.newMessageView.chatTableView.reloadData()
                            
                            print("All documents processed. Reloading table view now")
                            self.newMessageView.chatTableView.reloadData()
                            self.scrollToBottomChat()
                        }
                    }
                }
                else {
                    print("Failed to fetch messages")
                }
                print("MessageList after adding a message -- \(self.chatList)")
            }
        })
    }
    
    func scrollToBottomChat() {
        let numberOfSections = newMessageView.chatTableView.numberOfSections
        let numberOfRows = newMessageView.chatTableView.numberOfRows(inSection: numberOfSections - 1)
        
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
            newMessageView.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func generateUUID(_ emailList:[String]) -> String{
        print("generating UUID")
        let sortedEmails = emailList.sorted()
        let joinedEmails = sortedEmails.joined()
        
        let joinedEmailsData = Data(joinedEmails.utf8)
        let hashed = Insecure.MD5.hash(data: joinedEmailsData)
        
        return hashed.compactMap {
            String(format: "%02x", $0)
        }.joined()
    }
    
}
