//
//  CarsViewModel.swift
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
import simd

class CarsViewModel: ObservableObject {
    @Published private(set) var cars: [CarInGarage] = []
    let db = Firestore.firestore()
    let currentUid = Firebase.Auth.auth().currentUser!.uid
    @Published var uploading = false
    
    init() {
        getCars()
    }
    
    func getCars() {
        self.cars.removeAll()
        db.collection("users").document("\(currentUid)").collection("cars").addSnapshotListener{ querySnapshot, error in
            guard let docsData = querySnapshot?.documents else {
                print(String(describing: error?.localizedDescription))
                return
            }
            
            self.cars = docsData.compactMap{docData -> CarInGarage? in
                do {
                    let data_id = docData["id"] as? String
                    let data_brand = docData["brand"] as? String
                    let data_model = docData["model"] as? String
                    let data_year = docData["year"] as? Int
                    let data_imageUrl = docData["imageUrl"] as? String
                    let data_cv = docData["cv"] as? Int
                    let data_cc = docData["cc"] as? Int
                    let data_km = docData["km"] as? Int
                    let data_zero100s = docData["zero100sec"] as? Float
                    let data_addTs =  docData["addTimestamp"] as? Timestamp
                    let data_meets = docData["meets"] as? [String]
                    return CarInGarage(id: data_id!, brand: data_brand!, model: data_model!, year: data_year!, addTimestamp: data_addTs!.dateValue(), imageUrl: data_imageUrl, zero100secs: data_zero100s, km: data_km, cc: data_cc, cv: data_cv, meets: data_meets)
                }
            }
            self.cars.sort{$0.addTimestamp > $1.addTimestamp}
            do {
                let userDefaults = UserDefaults.standard
                let data = try JSONEncoder().encode(self.cars)
                userDefaults.set(data as Data, forKey: "carsInGarage")
            } catch {
                print("couldn't encode data")
            }
           
            
        }
    }
    
    func addCar(brand: String, model: String, year: Int, cv: Int?, cc: Int?, km: Int?, zero100: Float?, image: UIImage?, presentation: Binding<PresentationMode>) {
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
                                presentation.wrappedValue.dismiss()
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
                                    presentation.wrappedValue.dismiss()
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
                                    presentation.wrappedValue.dismiss()
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
                    presentation.wrappedValue.dismiss()
                }
            }
        }
    }
    
    func removeCar(carId: String, editPresentation: Binding<PresentationMode>, detailPresentation: Binding<PresentationMode>) {
        withAnimation{
            self.uploading = true
        }
        
        editPresentation.wrappedValue.dismiss()
        detailPresentation.wrappedValue.dismiss()
        
        self.db.collection("users").document(self.currentUid).collection("cars").document("\(carId)").delete() { err in
            if err != nil {
                print("Couldn't delete document")
            }
        }
        
        withAnimation{
            self.uploading = false
        }
    }
    
    func updateCar(carId: String, km: String, cc: String, cv: String, zero100: String, image: UIImage?) {
        withAnimation{
            self.uploading = true
        }
        
        var newData: Dictionary<String, Any> = [
            "zero100": zero100 == "" ? "" : Float(zero100)!,
            "km": km == "" ? "" : Int(km)!,
            "cc": cc == "" ? "" : Int(cc)!,
            "cv": cv == "" ? "" : Int(cv)!
        ]
        
        if let i = self.cars.firstIndex(where: {$0.id == carId}) {
            self.cars[i].km = km == "" ? nil : Int(km)!
            self.cars[i].zero100secs = zero100 == "" ? nil : Float(zero100)!
            self.cars[i].cc = cc == "" ? nil : Int(cc)!
            self.cars[i].cv = cv == "" ? nil : Int(cv)!
        }
        
        if image != nil {
            let ref = FirebaseStorage.Storage.storage().reference(withPath: "carsImgs/\(carId).jpg")
            if let imageData = image!.jpegData(compressionQuality: 0.5) {
                ref.putData(imageData){ metadata, error in
                    if error != nil {
                        print("Couldn't upload image to storage.")
                        self.db.collection("users").document(self.currentUid).collection("cars").document("\(carId)").updateData(newData)
                    }
                    ref.downloadURL{url, err in
                        if err != nil {
                            print("Failed to retrieve download url")
                            self.db.collection("users").document(self.currentUid).collection("cars").document("\(carId)").updateData(newData)
                        } else {
                            let imageUrl = url!.absoluteString
                            newData["imageUrl"] = imageUrl
                            self.db.collection("users").document(self.currentUid).collection("cars").document("\(carId)").updateData(newData)
                        }
                    }
                }
            }
        }
        else {
            self.db.collection("users").document(self.currentUid).collection("cars").document("\(carId)").updateData(newData)
        }
        
        withAnimation{
            self.uploading = false
        }
    }
}
