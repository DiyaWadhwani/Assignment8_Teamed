//
//  LoginFirebaseManager.swift
//  WA8_14
//
//  Created by Diya on 11/16/23.
//

import Foundation
import FirebaseFirestore

extension ViewController {
    
    func fetchUserChatsAtLogin() {
        
        print("fetching user chats")
        self.messageList.removeAll()
        if let currentUserEmail = self.currentUser!.email {
            
            let userCollection = database.collection("users").document(currentUserEmail).collection("chats")
            let chatCollection = database.collection("chats")
            
            userCollection.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching user chats: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found in user chats collection")
                    return
                }
                
                var chatUUIDList = [String]()
                
                for document in documents {
                    //                    var chatUUID = document.documentID
                    chatUUIDList.append(document.documentID)
                    
                }
                
                self.fetchLastMessages(for: chatUUIDList, from: chatCollection)
            }
        }
        else {
            print("unable to fetch useremail")
        }
    }
    
    func fetchLastMessages(for chatUUIDList: [String], from chatCollection: CollectionReference) {
        
        for chatUUID in chatUUIDList {
            let messagesCollection = chatCollection.document(chatUUID).collection("messages")
            
            // Query to get the last message
            
            messagesCollection.getDocuments { (querySnapshot, error) in
                if error == nil {
                    let messageCount = querySnapshot?.documents.count ?? 0
                    print("Message count for chat \(chatUUID): \(messageCount)")
                    messagesCollection.document("message\(messageCount-1)").getDocument { (querySnapshot, error) in
                        if error == nil {
                            if let documentData = querySnapshot?.data(){
                                if let messageText = documentData["message"] as? String,
                                   let timestamp = documentData["timestamp"] as? String,
                                   let recipient = documentData["recipient"] as? String {
                                    print("message -- \(messageText)")
                                    print("timestamp -- \(timestamp)")
                                    var message = Message(senderName: recipient, messageText: messageText)
                                    print("messageobject -- \(message)")
                                    self.messageList.append(message)
                                    print("messageList -- \(self.messageList)")
                                    
                                    DispatchQueue.main.async {
                                        self.userMessageView.tableViewMessages.reloadData()
                                    }
                                    
                                }
                            }
                        }
                        else{
                            print("Error fetching the last message document")
                        }
                    }
                    
                }
                else{
                    print("Error fetching message count for chat \(chatUUID): \(error?.localizedDescription.description)")
                }
            }
        }
    }
}
