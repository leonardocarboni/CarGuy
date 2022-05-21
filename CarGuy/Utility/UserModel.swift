//
//  UserModel.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 21/05/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserModel: ObservableObject {
    @Published var email = ""
    @Published var name = ""
    @Published var pfpUrl = ""
    @Published var reviews = [Review]()
    @Published var nCars = 0
    let db = Firestore.firestore()

    init() {
        getUserData()
    }
    
    func getUserData() {
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
            if data["name"] != nil && data["email"] != nil {
                self.name = data["name"] as! String
                self.email = data["email"] as! String
                
                if data["pfpUrl"] != nil {
                    self.pfpUrl = data["pfpUrl"] as! String
                }
                
                self.db.collection("users").document("\(currentUid)").collection("reviews").getDocuments{ doc, err in
                    if err != nil {
                        print ("Empty doc")
                        return
                    }
                    
                    //get reviews
                    
                }
            }
        }
    }
}
