//
//  Message.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 20/05/22.
//

import Foundation

struct Message: Identifiable, Codable, Hashable {
    var id: String
    var text: String
    var recieved: Bool
    var timestamp: Date
}
