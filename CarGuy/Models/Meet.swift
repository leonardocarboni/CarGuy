//
//  Meet.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 22/05/22.
//

import Foundation
import MapKit

struct Meet: Identifiable, Codable {
    let id: String
    let name: String
//    let coords: CLLocationCoordinate2D
    let latitude: Double
    let longitude: Double
    let timestamp: Date
    let city: String
    let creatorUid: String
    let imageUrl: String?
    let partecipantUids: [String]
}
