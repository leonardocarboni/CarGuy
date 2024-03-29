//
//  MessagesViewModel.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 20/05/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class MessagesViewModel: ObservableObject {
    
    @Published private(set) var messages: [Message] = []
    @Published private(set) var lastMessageId = ""
    @Published private(set) var lastMessageTimestamp = Date()
    
    var chatId: String
    let db = Firestore.firestore()
    private var currentUid = Firebase.Auth.auth().currentUser?.uid
    
    init(chatId: String) {
        self.chatId = chatId
        getMessages()
    }
    
    /**
     Ottiene la lista dei messaggi della relativa chat
     */
    func getMessages() {
        db.collection("chats").document("\(chatId)").collection("messages").addSnapshotListener{ querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print(String(describing: error?.localizedDescription))
                return
            }
            
            self.messages = documents.compactMap{ doc -> Message? in
                do {
                    let data = doc.data()
                    let data_id =  data["id"] as? String
                    let data_recieved = data["sender"] as? String != self.currentUid
                    let data_text =  data["text"] as? String
                    let data_ts =  data["timestamp"] as? Timestamp
                    return Message(id: data_id!, text: data_text!, recieved: data_recieved, timestamp: data_ts!.dateValue())
                }
            }
            self.messages.sort{$0.timestamp < $1.timestamp}
            if let lastId = self.messages.last?.id {
                self.lastMessageId = lastId
            }
            if let lastTs = self.messages.last?.timestamp {
                self.lastMessageTimestamp = lastTs
            }
        }
    }
    
    /**
     Effettua l'invio di un messaggio nella relativa chat
     */
    func sendMessage(text: String) {
        do {
            let uuid = UUID()
            db.collection("chats").document("\(chatId)").collection("messages").document("\(uuid)").setData([
                "id": "\(uuid)",
                "sender": "\(self.currentUid!)",
                "text": "\(text)",
                "timestamp": Timestamp()
            ])
        }
    }
}
