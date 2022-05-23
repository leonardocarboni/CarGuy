//
//  Chat.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 20/05/22.
//

import Foundation

struct Chat: Identifiable, Hashable {
    var id: String
    var toId: String
    var toName: String
    var toPfpUrl: String
    var messagesManager: MessagesViewModel
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.id == rhs.id && lhs.toId == rhs.toId
    }
}
