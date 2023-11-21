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
                
                //update userList
                self.userList = users
                
                //remove logged in user from the list of contacts
                if let currentUserDisplayName = self.currentUser?.displayName {
                    self.userList = self.userList.filter { $0.name != currentUserDisplayName }
                }
                
                //update contact names
                for user in self.userList {
                    self.userNames.append(user.name)
                }
            }
        }
    }
    
    func sendChatToUser(_ toUsername: String, _ message: String){
        
        print("sending chat to user")
        
        self.newMessageView.recipientTextField.isEnabled = false
        self.newMessageView.recipientDropDownTable.isHidden = true
        self.newMessageView.messageTextView.text = ""
        
        //used to create timestamp of message
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let dateString = dateFormatter.string(from: currentDate)
        
        //variable to store chatUUID after generation
        var chatUUID: String = ""
        
        let chatCollection = database.collection("chats")
        
        if let fromUser = self.currentUser {
            if let email1 = fromUser.email {
                for contact in userList {
                    if toUsername == contact.name {
                        var email2 = contact.email
                        
                        //generation of chatUUID for the 2 users in conversation
                        var emailList = [String]()
                        emailList.append(email1)
                        emailList.append(email2)
                        chatUUID = generateUUID(emailList)
                        
                        //creating the chatObject to store chats
                        var chatObject = Chat(timestamp: dateString, message: message, toUser: email2, fromUser: email1)
                        
                        let messageCollection = chatCollection.document(chatUUID).collection("messages")
                        var messageCollectionCount = 0
                        
                        messageCollection.getDocuments(completion: { (querySnapshot, error) in
                            
                            if let error = error {
                                print("Failed to fetch messageCollection documents: \(error.localizedDescription.description)")
                            }
                            else{
                                
                                //fetching number of messages
                                messageCollectionCount = querySnapshot?.documents.count ?? 0
                                print("No. of documents in messages collection: \(messageCollectionCount)")
                                
                                //creating new message/chat document
                                let newMessageDocName = "message\(messageCollectionCount)"
                                
                                messageCollection.document(newMessageDocName).setData(chatObject.asDictionary) { error in
                                    
                                    if let error = error {
                                        print("Failed to create new message document: \(error.localizedDescription.description)")
                                    }
                                    else {
                                        
                                        //new document created
                                        var usersInConversation = [String]()
                                        usersInConversation.append(fromUser.displayName!)
                                        usersInConversation.append(toUsername)
                                        
                                        //updating users in conversation and adding chatUUID to specific user documents
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
        
        //fetching documents of the 2 users in conversation
        var user1Collection = userCollection.document(emails[0])
        var user2Collection = userCollection.document(emails[1])
        
        //user1 document
        user1Collection.getDocument{ (user1DocSnapshot, error) in
            
            if let error = error {
                print("Error fetching user1 document: \(error.localizedDescription)")
            } else {
                
                if let user1Data = user1DocSnapshot?.data(),
                   
                    //creating chat collection in user document
                   let chatsCollection1 = user1Data["chats"] as? [String: Any],
                   
                    //creation of document in chat collection of user if does not exist
                   let chatRefDocument1 = chatsCollection1["chatRef"] as? [String: Any] {
                    
                    //chatRef document exists
                    
                } else {
                    
                    //creating chatRef document
                    self.addChatRefDocument(to: user1Collection.collection("chats"), chatUUID, emails[1], usersInConversation[1])
                }
            }
        }
        
        //user2 document
        user2Collection.getDocument{ (user2DocSnapshot, error) in
            
            if let error = error {
                print("Error fetching user2 document: \(error.localizedDescription)")
            } else {
                
                if let user2Data = user2DocSnapshot?.data(),
                   
                    //creating chat collection in user document
                   let chatsCollection2 = user2Data["chats"] as? [String: Any],
                   
                    //creation of document in chat collection of user if does not exist
                   let chatRefDocument2 = chatsCollection2["chatRef"] as? [String: Any] {
                    
                    //chatRef document exists
                    
                } else {
                    
                    //creating chatRef document
                    self.addChatRefDocument(to: user2Collection.collection("chats"), chatUUID, emails[0], usersInConversation[0])
                }
            }
        }
    }
    
    func addChatRefDocument(to chatCollection: CollectionReference, _ chatUUID: String, _ email: String, _ userName: String) {
        
        //data in chatRef document
        let chatRefDocumentData = [
            "userNameInConversation": userName,
            "userEmailInConversation": email
        ]
        
        //adding chatRef document to user specific chatCollection
        let newDocument = chatCollection.document(chatUUID)
        newDocument.setData(chatRefDocumentData) { error in
            if let error = error {
                print("Error adding 'chatRef' document: \(error.localizedDescription)")
            } else {
                print("Added 'chatRef' document successfully.")
                
                //message sent to a user for the first time
                if self.chatList.isEmpty {
                    self.loadChatsOnUserViewScreen(chatUUID)
                }
            }
        }
    }
    
    func loadChatsOnUserViewScreen(_ chatUUID: String) {
        
        //variable to detect any new messages
        var hasNewMessage = false
        
        let chatsCollection = database.collection("chats")
        let messageCollection = chatsCollection.document(chatUUID).collection("messages")
        
        var query = messageCollection.order(by: "timestamp", descending: false)
        
        query.addSnapshotListener(includeMetadataChanges: false, listener: { (querySnapshot, error) in
            
            if error == nil {
                
                if let querySnapshot = querySnapshot{
                    print("fetched documents in messagecollection")
                    
                    //clearing chatList to fetch all chats
                    self.chatList.removeAll()
                    
                    for doc in querySnapshot.documents {
                        
                        let data = doc.data()
                        
                        //fetching chat data
                        if let timestamp = data["timestamp"] as? String,
                           let messageText = data["message"] as? String,
                           let fromUser = data["fromUser"] as? String,
                           let toUser = data["toUser"] as? String {
                            
                            //creating chatObject
                            let chat = Chat(timestamp: timestamp, message: messageText, toUser: toUser, fromUser: fromUser)
                            
                            //checking if chatObject exists in the list
                            if self.chatList.firstIndex(where: { $0.timestamp == chat.timestamp }) == nil {
                                
                                //chatObject is new and needs to be added in the chatList
                                self.chatList.append(chat)
                                hasNewMessage = true
                            }
                        }
                        else{
                            print("Failed to fetch data from doc")
                        }
                    }
                    
                    //fetching latest document created
                    if let lastDocument = querySnapshot.documents.last {
                        self.lastDocumentSnapshot = lastDocument
                    }
                    
                    //reloading chatTableView if a new message has been detected and scrolling to the bottom
                    if hasNewMessage {
                        DispatchQueue.main.async {
                            
                            //all documents loaded
                            self.newMessageView.chatTableView.reloadData()
                            self.scrollToBottomChat()
                        }
                    }
                }
                else {
                    print("Failed to fetch messages")
                }
            }
        })
    }
    
    //provided code from assignment to scrollToLastChat
    func scrollToBottomChat() {
        let numberOfSections = newMessageView.chatTableView.numberOfSections
        let numberOfRows = newMessageView.chatTableView.numberOfRows(inSection: numberOfSections - 1)
        
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
            newMessageView.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    //generating chatUUID to create a chat reference for each user
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
