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
    @Published var avgStars: Float?
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
                
                self.db.collection("users").document("\(currentUid)").collection("cars").getDocuments{ doc, err in
                    if err != nil {
                        print ("Empty doc")
                        return
                    }
                    self.nCars = doc!.documents.count
                }
                
                self.db.collection("users").document("\(currentUid)").collection("reviews").getDocuments{ doc, err in
                    if err != nil {
                        print ("Error Fetching Reviews")
                        return
                    }
                    if doc!.documents.count > 0 {
                        var starsSum = 0
                        for r in doc!.documents {
                            let rData = r.data()
                            let rId = rData["id"] as! String
                            let rText = rData["text"] as! String
                            let rStars = rData["stars"] as! Int
                            let reviewerUid = rData["reviewerUid"] as! String
                            var reviewerPfp = ""
                            var reviewerName = ""
                            starsSum += rStars
                            
                            self.db.collection("users").document("\(reviewerUid)").getDocument{ userDoc, userErr in
                                if userErr != nil {
                                    print("Error fetching user")
                                    self.reviews.append(Review(id: rId, text: rText, stars: rStars, from: reviewerName, pfpUrl: reviewerPfp))
                                    return
                                }
                                guard let userData = userDoc!.data() else {
                                    print("Error fetching user")
                                    self.reviews.append(Review(id: rId, text: rText, stars: rStars, from: reviewerName, pfpUrl: reviewerPfp))
                                    return
                                }
                                reviewerPfp = userData["pfpUrl"] as! String
                                reviewerName = userData["name"] as! String
                                self.reviews.append(Review(id: rId, text: rText, stars: rStars, from: reviewerName, pfpUrl: reviewerPfp))
                            }
                        }
                        self.avgStars = Float(starsSum) / Float(doc!.documents.count)
                    }
                }
            }
        }
    }
}
