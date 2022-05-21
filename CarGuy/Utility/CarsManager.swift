//
//  CarsManager.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 20/05/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import UIKit
import SwiftUI

class CarsManager: ObservableObject {
    @Published private(set) var cars: [CarInGarage] = []
    let db = Firestore.firestore()
    let currentUid = Firebase.Auth.auth().currentUser!.uid
    @Published var uploading = false
    
    init() {
        getCars()
    }
    
    func getCars() {
        db.collection("users").document("\(currentUid)").collection("cars").addSnapshotListener{ querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print(String(describing: error?.localizedDescription))
                return
            }
            
            self.cars = documents.compactMap{ doc -> CarInGarage? in
                do {
                    let data = doc.data()
                    let data_id = data["id"] as? String
                    let data_brand = data["brand"] as? String
                    let data_model = data["model"] as? String
                    let data_year = data["year"] as? Int
                    let data_imageUrl = data["imageUrl"] as? String
                    let data_cv = data["cv"] as? Int
                    let data_cc = data["cc"] as? Int
                    let data_km = data["km"] as? Int
                    let data_zero100s = data["zero100sec"] as? Float
                    let data_addTs =  data["addTimestamp"] as? Timestamp
                    return CarInGarage(id: data_id!, brand: data_brand!, model: data_model!, year: data_year!, addTimestamp: data_addTs!.dateValue(), imageUrl: data_imageUrl, zero100secs: data_zero100s, km: data_km, cc: data_cc, cv: data_cv)
                }
            }
            self.cars.sort{$0.addTimestamp > $1.addTimestamp}
        }
    }
    
    func addCar(brand: String, model: String, year: Int, cv: Int?, cc: Int?, km: Int?, zero100: Float?, image: UIImage?) {
        do {
            withAnimation{
                self.uploading = true
            }
            let uuid = UUID()
            var imageUrl = ""
            //Image Upload
            if image != nil {
                let ref = FirebaseStorage.Storage.storage().reference(withPath: "carsImgs/\(uuid).jpg")
                if let imageData = image!.jpegData(compressionQuality: 0.5) {
                    ref.putData(imageData){ metadata, error in
                        if error != nil {
                            print("Couldn't upload image to storage.")
                            self.db.collection("users").document(self.currentUid).collection("cars").document("\(uuid)").setData([
                                "id": "\(uuid)",
                                "brand": "\(brand)",
                                "model": "\(model)",
                                "year": year,
                                "cv": cv ?? "",
                                "cc": cc ?? "",
                                "km": km ?? "",
                                "zero100": zero100 ?? "",
                                "imageUrl": "\(imageUrl)",
                                "addTimestamp": Timestamp()
                            ])
                            withAnimation{
                                self.uploading = false
                            }
                        }
                        ref.downloadURL{url, err in
                            if err != nil {
                                print("Failed to retrieve download url")
                                self.db.collection("users").document(self.currentUid).collection("cars").document("\(uuid)").setData([
                                    "id": "\(uuid)",
                                    "brand": "\(brand)",
                                    "model": "\(model)",
                                    "year": year,
                                    "cv": cv ?? "",
                                    "cc": cc ?? "",
                                    "km": km ?? "",
                                    "zero100": zero100 ?? "",
                                    "imageUrl": "\(imageUrl)",
                                    "addTimestamp": Timestamp()
                                ])
                                withAnimation{
                                    self.uploading = false
                                }
                            } else {
                                imageUrl = url!.absoluteString
                                print(imageUrl)
                                self.db.collection("users").document(self.currentUid).collection("cars").document("\(uuid)").setData([
                                    "id": "\(uuid)",
                                    "brand": "\(brand)",
                                    "model": "\(model)",
                                    "year": year,
                                    "cv": cv ?? "",
                                    "cc": cc ?? "",
                                    "km": km ?? "",
                                    "zero100": zero100 ?? "",
                                    "imageUrl": "\(imageUrl)",
                                    "addTimestamp": Timestamp()
                                ])
                                withAnimation{
                                    self.uploading = false
                                }
                            }
                        }
                    }
                }
            } else {
                self.db.collection("users").document(self.currentUid).collection("cars").document("\(uuid)").setData([
                    "id": "\(uuid)",
                    "brand": "\(brand)",
                    "model": "\(model)",
                    "year": year,
                    "cv": cv ?? "",
                    "cc": cc ?? "",
                    "km": km ?? "",
                    "zero100": zero100 ?? "",
                    "imageUrl": "",
                    "addTimestamp": Timestamp()
                ])
                withAnimation{
                    self.uploading = false
                }
            }
        }
    }
}
