//
//  UserViewModel.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 21/05/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import UIKit
import SwiftUI

class UserViewModel: ObservableObject {
    @Published var email = ""
    @Published var name = ""
    @Published var pfpUrl = ""
    @Published var reviews = [Review]()
    @Published var nCars = 0
    @Published var avgStars: Float?
    @Published var updating = false
    
    let db = Firestore.firestore()
    
    init() {
        getUserData(currentUid: Firebase.Auth.auth().currentUser!.uid)
    }
    
    init(uid: String) {
        getUserData(currentUid: uid)
    }
    
    func getUserData(currentUid: String) {
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
                
                self.db.collection("users").document("\(currentUid)").collection("reviews").addSnapshotListener{ doc, err in
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
                            self.reviews.removeAll()
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
    
    func updateUserDetails(name: String, pfp: UIImage?) {
        withAnimation{
            self.updating = true
        }
        let currentUid = Firebase.Auth.auth().currentUser!.uid
        
        if pfp != nil {
            let ref = FirebaseStorage.Storage.storage().reference(withPath: "profilePictures/\(currentUid).jpg")
            if let imageData = pfp!.jpegData(compressionQuality: 0.5) {
                ref.putData(imageData){ metadata, error in
                    if error != nil {
                        print("Couldn't upload image to storage.")
                    }
                    ref.downloadURL{url, err in
                        if err != nil {
                            print("Failed to retrieve download url")
                        } else {
                            let imageUrl = url!.absoluteString
                            self.db.collection("users").document(currentUid).updateData([
                                "name": "\(name)",
                                "pfpUrl": imageUrl
                            ])
                        }
                    }
                }
            }
        } else {
            self.db.collection("users").document(currentUid).updateData([
                "name": "\(name)"
            ])
        }
        withAnimation{
            self.updating = false
        }
    }
    
    func addReview(description: String, stars: Int, toUid: String) {
        let reviewUuid = UUID()
        db.collection("users").document("\(toUid)").collection("reviews").document("\(reviewUuid)").setData([
            "id": "\(reviewUuid)",
            "reviewerUid": "\(Firebase.Auth.auth().currentUser!.uid)",
            "stars": stars,
            "text": description
        ])
    }
}
