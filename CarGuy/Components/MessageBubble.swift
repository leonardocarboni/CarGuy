//
//  MessageBubble.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 20/05/22.
//

import SwiftUI

struct MessageBubble: View {
    @State private var showTime = false
    var message: Message
    var body: some View {
        
        VStack(alignment: message.recieved ? .leading : .trailing) {
            HStack {
                Text(message.text).padding().background(message.recieved ? Color.gray : Color.blue).cornerRadius(30).foregroundColor(.white)
            }.frame(maxWidth: 300, alignment: message.recieved ? .leading : .trailing).onTapGesture {
                showTime.toggle()
            }
            if showTime {
                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))").font(.caption2).padding(message.recieved ? .leading : .trailing, 20)
            }
        }.frame(maxWidth: .infinity, alignment: message.recieved ? .leading : .trailing).padding(message.recieved ? .leading : .trailing).padding(.horizontal, 10)
    }
    
}
