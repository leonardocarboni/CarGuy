//
//  ChatsViewModel.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 20/05/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI


class ChatsViewModel: ObservableObject {
    @Published private(set) var chats: [Chat] = []
    let db = Firestore.firestore()
    
    init() {
        getChats()
    }
    
    /**
     Ottiene la lista delle chat dell'utente attuale
     */
    func getChats() {
        let currentUid = Firebase.Auth.auth().currentUser!.uid
        db.collection("users").document("\(currentUid)").addSnapshotListener{ documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            
            let x: [String]? = data["chats"] as? [String]
            if x == nil {
                return
            }
            for ch in x! {
                self.db.collection("chats").document(ch).getDocument{ doc, err in
                    if err != nil {
                        print("Document data was empty.")
                        return
                    }
                    
                    if doc == nil || doc!.data() == nil {
                        return
                    }
                    
                    let u1 = doc?.data()!["user1"] as? String
                    let u2 = doc?.data()!["user2"] as? String
                    
                    var toId: String
                    if (u1 != currentUid && u2 != currentUid) || u1 == nil || u2 == nil {
                        //errore, l'utente non è in nessuno dei due campi
                        return
                    }
                    print(u1!)
                    print(u2!)
                    print("\n\n\n\n")
                    if u1 == currentUid {
                        toId = u2!
                    } else {
                        toId = u1!
                    }
                    
                    self.db.collection("users").document(toId).getDocument{ doc2, err2 in
                        let toName = doc2?.data()!["name"] as? String
                        let toPfpUrl = doc2?.data()!["pfpUrl"] as? String
                        let a = Chat(id: ch, toId: toId, toName: toName!, toPfpUrl: toPfpUrl!, messagesManager: MessagesViewModel(chatId: ch))
                        self.chats.append(a)
                    }
                }
            }
            self.chats.sort{$0.messagesManager.lastMessageTimestamp < $1.messagesManager.lastMessageTimestamp}
        }
    }
    
    /**
     Crea una chat tra l'utente attuale e un altro utente
     */
    func createChat(toId: String, completed: Binding<Bool>) {
        let chatUuid = UUID()
        let currentUid = Firebase.Auth.auth().currentUser!.uid
        db.collection("chats").document("\(chatUuid)").setData([
            "id": "\(chatUuid)",
            "user1": "\(currentUid)",
            "user2": "\(toId)"
        ])
        
        db.collection("users").document("\(currentUid)").updateData([
            "chats": FieldValue.arrayUnion(["\(chatUuid)"])
        ])
        
        db.collection("users").document("\(toId)").updateData([
            "chats": FieldValue.arrayUnion(["\(chatUuid)"])
        ])
        
        
        completed.wrappedValue.toggle()
    }
}
