//
//  MeetsViewModel.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 22/05/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation
import UIKit
import SwiftUI
import FirebaseStorage

class MeetsViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    @Published private(set) var meets = [Meet]()
    @Published var uploading = false
    
    init() {
        getMeets()
    }
    
    func getMeets() {
        db.collection("meets").addSnapshotListener{ querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print(String(describing: error?.localizedDescription))
                return
            }
            
            self.meets = documents.compactMap{ doc -> Meet? in
                do {
                    let data = doc.data()
                    let data_id =  data["id"] as? String
                    let data_name =  data["name"] as? String
                    let data_coords = data["coords"] as? GeoPoint
                    //                    let cll_coords = CLLocationCoordinate2D(latitude: data_coords!.latitude, longitude: data_coords!.longitude)
                    let data_ts =  data["timestamp"] as? Timestamp
                    let data_city = data["city"] as? String
                    let data_creatorUid = data["creatorUid"] as? String
                    let data_imageUrl = data["imageUrl"] as? String
                    let data_partecipantUids = data["partecipants"] as? [String]
                    return Meet(id: data_id!, name: data_name!, latitude: data_coords!.latitude, longitude: data_coords!.longitude, timestamp: data_ts!.dateValue(), city: data_city!, creatorUid: data_creatorUid!, imageUrl: data_imageUrl, partecipantUids: data_partecipantUids != nil ? data_partecipantUids! : [String]())
                }
            }
            self.meets.sort{$0.timestamp < $1.timestamp}
            do {
                let userDefaults = UserDefaults.standard
                let data = try JSONEncoder().encode(self.meets)
                userDefaults.set(data as Data, forKey: "meets")
            } catch {
                print("couldn't encode data")
            }
        }
    }
    
    func subscribeCar(carId: String, meetId: String) {
        db.collection("meets").document("\(meetId)").updateData([
            "partecipants": FieldValue.arrayUnion(["\(carId)"])
        ])
        
        let currentUid = Firebase.Auth.auth().currentUser?.uid
        db.collection("users").document("\(currentUid!)").collection("cars").document("\(carId)").updateData([
            "meets": FieldValue.arrayUnion(["\(meetId)"])
        ])
        
    }
    
    func removeCar(carId: String, meetId: String) {
        db.collection("meets").document("\(meetId)").updateData([
            "partecipants": FieldValue.arrayRemove(["\(carId)"])
        ])
        
        let currentUid = Firebase.Auth.auth().currentUser?.uid
        db.collection("users").document("\(currentUid!)").collection("cars").document("\(carId)").updateData([
            "meets": FieldValue.arrayRemove(["\(meetId)"])
        ])
    }
    
    func addMeet(name: String, city: String, date: Date, place: Place, presentation: Binding<PresentationMode>, image: UIImage?) {
        let currentUid = Firebase.Auth.auth().currentUser?.uid
        withAnimation{
            uploading = true
        }
        let uuid = UUID()
        var imageUrl = ""
        
        if image != nil {
            let ref = FirebaseStorage.Storage.storage().reference(withPath: "meetImages/\(uuid).jpg")
            if let imageData = image!.jpegData(compressionQuality: 0.5) {
                ref.putData(imageData){ metadata, error in
                    if error != nil {
                        print("Couldn't upload image to storage.")
                        self.db.collection("meets").document("\(uuid)").setData([
                            "id": "\(uuid)",
                            "creatorUid": "\(currentUid!)",
                            "name": "\(name)",
                            "timestamp": date,
                            "city": "\(city)",
                            "coords": GeoPoint(latitude: place.latitude, longitude: place.longitude),
                            "imageUrl": "\(imageUrl)",
                            "partecipants": []
                        ])
                        withAnimation{
                            self.uploading = false
                            presentation.wrappedValue.dismiss()
                        }
                    }
                    ref.downloadURL{url, err in
                        if err != nil {
                            print("Failed to retrieve download url")
                            self.db.collection("meets").document("\(uuid)").setData([
                                "id": "\(uuid)",
                                "creatorUid": "\(currentUid!)",
                                "name": "\(name)",
                                "timestamp": date,
                                "city": "\(city)",
                                "coords": GeoPoint(latitude: place.latitude, longitude: place.longitude),
                                "imageUrl": "\(imageUrl)",
                                "partecipants": []
                            ])
                            withAnimation{
                                self.uploading = false
                                presentation.wrappedValue.dismiss()
                            }
                        } else {
                            imageUrl = url!.absoluteString
                            print(imageUrl)
                            self.db.collection("meets").document("\(uuid)").setData([
                                "id": "\(uuid)",
                                "creatorUid": "\(currentUid!)",
                                "name": "\(name)",
                                "timestamp": date,
                                "city": "\(city)",
                                "coords": GeoPoint(latitude: place.latitude, longitude: place.longitude),
                                "imageUrl": "\(imageUrl)",
                                "partecipants": []
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
            self.db.collection("meets").document("\(uuid)").setData([
                "id": "\(uuid)",
                "creatorUid": "\(currentUid!)",
                "name": "\(name)",
                "timestamp": date,
                "city": "\(city)",
                "coords": GeoPoint(latitude: place.latitude, longitude: place.longitude),
                "imageUrl": "\(imageUrl)",
                "partecipants": []
            ])
            withAnimation{
                self.uploading = false
                presentation.wrappedValue.dismiss()
            }
        }
    }
}
