//
//  Assistance.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 23/05/22.
//

import Foundation

struct Assistance: Identifiable {
    var id: String
    var creatorUid: String
    var type: String
    var description: String
    var priceOffer: Int
    var latitude: Double
    var longitude: Double
    var completed: Bool
    var acceptedBy: String
    var addTimestamp: Date
    var pfpUrl: String
    var name: String
    var car: String
}
