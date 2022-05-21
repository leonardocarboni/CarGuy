//
//  MessageHeader.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 20/05/22.
//

import SwiftUI

struct MessageHeader: View {
    var body: some View {
        HStack {
            CircleImage(imageUrl: "https://images.unsplash.com/photo-1601934066555-3357c19ddb6e?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=60&raw_url=true&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDN8dG93SlpGc2twR2d8fGVufDB8fHx8&auto=format&fit=crop&w=500", diameter: 70).padding()
            Text("Maria Foschi").bold().padding()
            
        }
    }
}

struct DMTitle_Previews: PreviewProvider {
    static var previews: some View {
        MessageHeader()
    }
}
