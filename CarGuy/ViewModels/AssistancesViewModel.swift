//
//  AssistancesViewModel.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 23/05/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import simd
import SwiftUI

class AssistancesViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    @Published private(set) var assistances = [Assistance]()
    
    init() {
        getAssistances()
    }
    
    /**
     Ottiene la lista delle assistenze
     */
    func getAssistances() {
        db.collection("assistances").addSnapshotListener{ querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print(String(describing: error?.localizedDescription))
                return
            }
            
            self.assistances = []
            if documents.count > 0 {
                for doc in documents {
                    let data = doc.data()
                    let data_id = data["id"] as? String
                    let data_creatorUid =  data["creatorUid"] as? String
                    let data_type =  data["type"] as? String
                    let data_coords = data["coords"] as? GeoPoint
                    let data_description =  data["description"] as? String
                    let data_addTimestamp = data["addTimestamp"] as? Timestamp
                    let data_priceOffer = data["priceOffer"] as? Int
                    let data_acceptedBy = data["acceptedBy"] as? String
                    let data_car = data["car"] as? String
                    var pfpUrl = ""
                    var name = ""
                    self.db.collection("users").document("\(data_creatorUid!)").getDocument{ userDoc, userErr in
                        if userErr != nil {
                            print("Error fetching user")
                            self.assistances.append(Assistance(id: data_id!, creatorUid: data_creatorUid!, type: data_type!.capitalized, description: data_description!, priceOffer: data_priceOffer!, latitude: data_coords!.latitude, longitude: data_coords!.longitude, completed: data_acceptedBy! != "", acceptedBy: data_acceptedBy!, addTimestamp: data_addTimestamp!.dateValue(), pfpUrl: pfpUrl, name: name, car: data_car!))
                            return
                        }
                        guard let userData = userDoc!.data() else {
                            print("Error fetching user")
                            self.assistances.append(Assistance(id: data_id!, creatorUid: data_creatorUid!, type: data_type!.capitalized, description: data_description!, priceOffer: data_priceOffer!, latitude: data_coords!.latitude, longitude: data_coords!.longitude, completed: data_acceptedBy! != "", acceptedBy: data_acceptedBy!, addTimestamp: data_addTimestamp!.dateValue(), pfpUrl: pfpUrl, name: name, car: data_car!))
                            return
                        }
                        pfpUrl = userData["pfpUrl"] as! String
                        name = userData["name"] as! String
                        self.assistances.append(Assistance(id: data_id!, creatorUid: data_creatorUid!, type: data_type!.capitalized, description: data_description!, priceOffer: data_priceOffer!, latitude: data_coords!.latitude, longitude: data_coords!.longitude, completed: data_acceptedBy! != "", acceptedBy: data_acceptedBy!, addTimestamp: data_addTimestamp!.dateValue(), pfpUrl: pfpUrl, name: name, car: data_car!))
                    }
                }
            }
        }
    }
    
    /**
     Segnala l'accettazione di una assistenza da parte
     */
    func acceptAssistance(assistanceId: String) {
        let index = self.assistances.firstIndex(where: {$0.id == assistanceId})!
        self.assistances[index].completed = true
        
        db.collection("assistances").document("\(assistanceId)").updateData([
            "acceptedBy": "\(Firebase.Auth.auth().currentUser!.uid)",
            "completed": "yes"
        ])
    }
    
    /**
     Aggiunge una assistenza
     */
    func addAssistance(car: CarInGarage, assistanceType: String, description: String, priceOffer: Int, latitude: Double, longitude: Double) {
        do {
            let uuid = UUID()
            db.collection("assistances").document("\(uuid)").setData([
                "id": "\(uuid)",
                "carId": "\(car.id)",
                "coords": GeoPoint(latitude: latitude, longitude: longitude),
                "type": "\(assistanceType)",
                "car": "\(car.brand) \(car.model)",
                "creatorUid": "\(Firebase.Auth.auth().currentUser!.uid)",
                "description": "\(description)",
                "priceOffer": priceOffer,
                "addTimestamp": Timestamp(),
                "acceptedBy": "",
            ])
        }
    }
    
}
