//
//  CarInGarage.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 17/05/22.
//

import Foundation

struct CarInGarage: Identifiable{
    let brand: String
    let model: String
    let year: Int
    let id = UUID()
    let imageUrl: String
}
