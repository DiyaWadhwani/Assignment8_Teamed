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
                print("All users fetched -- \(users)")
                self.userList = users
                
                if let currentUserDisplayName = self.currentUser?.displayName {
                    self.userList = self.userList.filter { $0.name != currentUserDisplayName }
                }
                
                print("UserList after removing the logged in user -- \(self.userList)")
                
                for user in self.userList {
                    self.userNames.append(user.name)
                }
                print("List of names -- \(self.userNames)")
                //                self.newMessageView.pickerView.reloadAllComponents()
            }
        }
    }
    
    func sendChatToUser(_ user: String, _ message: String) -> String{
        
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
                    if user == contact.name {
                        var email2 = contact.email
                        
                        var emailList = [String]()
                        emailList.append(email1)
                        emailList.append(email2)
                        
                        chatUUID = generateUUID(emailList)
                        
                        var messageData = [
                            "user1": email1,
                            "user2": email2,
                            "recipient": user,
                            "message": message,
                            "timestamp": dateString
                        ]
                        
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
                                messageCollection.document(newMessageDocName).setData(messageData) { error in
                                    if let error = error {
                                        print("Failed to create new message document: \(error.localizedDescription.description)")
                                    }
                                    else {
                                        print("New document added succesfully")
                                        self.addChatReferenceIDToUsers(chatUUID, emailList)
                                    }
                                }
                            }
                        })
                    }
                }
            }
        }
        return chatUUID
    }
    
    func addChatReferenceIDToUsers(_ chatUUID: String, _ emails: [String]) {
        
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
                    self.addChatRefDocument(to: user1Collection.collection("chats"), chatUUID, emails[1])
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
                    self.addChatRefDocument(to: user2Collection.collection("chats"), chatUUID, emails[0])
                }
            }
        }
    }
    
    func addChatRefDocument(to chatCollection: CollectionReference, _ chatUUID: String, _ email: String) {
        let chatRefDocumentData = [
            // Add any fields you want in the "chatRef" document
            "toUser": email,
        ]
        
        // Add the "chatRef" document to the "chats" collection
        let newDocument = chatCollection.document(chatUUID)
        newDocument.setData(chatRefDocumentData) { error in
            if let error = error {
                print("Error adding 'chatRef' document: \(error.localizedDescription)")
            } else {
                print("Added 'chatRef' document successfully.")
                self.loadChatsOnUserViewScreen(chatUUID)
            }
        }
    }
    
    func loadChatsOnUserViewScreen(_ chatUUID: String) {
        newMessageView.messageTextField.text = ""
        self.messageList.removeAll()
        
//        print("Loading chats for chatID \(chatUUID)")
        
        let chatsCollection = database.collection("chats")
        let messageCollection = chatsCollection.document(chatUUID).collection("messages")
//        print("chatscollection -- \(chatsCollection)")
//        print("messagecollection -- \(messageCollection)")
        
        //implement table view for chats
        messageCollection.getDocuments { (querySnapshot, error) in
            
            if error == nil {
//                print("fetched documents in messagecollection")
                for doc in querySnapshot!.documents {
                    let data = doc.data()
//                    print("data in doc -- \(data)")
                    if let timestamp = data["timestamp"] as? String,
                       let messageText = data["message"] as? String {
                        let message = (timeStamp: timestamp, messageText: messageText)
//                        print("Message recieved -- \(message)")
                        self.messageList.append(message)
                    }
                }
            }
            else {
                print("Failed to fetch messages")
            }
            print("MessageList after adding a message -- \(self.messageList)")
            self.newMessageView.chatTableView.reloadData()
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
