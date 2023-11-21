//
//  LoginFirebaseManager.swift
//  WA8_14
//
//  Created by Diya on 11/16/23.
//

import Foundation
import FirebaseFirestore

extension ViewController {
    
    func fetchUserMessagesAtLogin() {
        
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
                
                var chatUserMap: [String: String] = [:]
                
                for document in documents {
                    
                    let chatUUID = document.documentID
                    let recipient = document["userNameInConversation"] as? String
                    chatUserMap[chatUUID] = recipient
                    
                }
                
                //get latest chat of the conversation
                self.fetchLastMessage(for: chatUserMap, from: chatCollection)
            }
        }
        else {
            print("unable to fetch useremail")
        }
    }
    
    func fetchLastMessage(for chatUserMap: [String: String], from chatCollection: CollectionReference) {
        
        self.messageList.removeAll()
        
        for (chatUUID, recipient) in chatUserMap {
            
            let messagesCollection = chatCollection.document(chatUUID).collection("messages")
            
            //get latest message
            messagesCollection.getDocuments(completion: { (querySnapshot, error) in
                
                if error == nil {
                    
                    let messageCount = querySnapshot?.documents.count ?? 0
                    
                    //fetching messageCount-1th message
                    messagesCollection.document("message\(messageCount-1)").getDocument(completion: { (querySnapshot, error) in
                        
                        if error == nil {
                            if let documentData = querySnapshot?.data(){
                                
                                if let messageText = documentData["message"] as? String {
                                    var message = Message(senderName: recipient, messageText: messageText, chatUUID: chatUUID)
                                    
                                    self.messageList.append(message)
                                    
                                    DispatchQueue.main.async {
                                        self.userMessageView.tableViewMessages.reloadData()
                                    }
                                    
                                }
                            }
                        }
                        else{
                            print("Error fetching the last message document: \(error?.localizedDescription.description)")
                        }
                    })
                    
                }
                else{
                    print("Error fetching message count for chat \(chatUUID): \(error?.localizedDescription.description)")
                }
            })
        }
    }
}
