//
//  Review.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 20/05/22.
//

import Foundation

struct Review: Identifiable {
    let id : String
    let text : String
    let stars: Int
    let from: String
    let pfpUrl: String
}
