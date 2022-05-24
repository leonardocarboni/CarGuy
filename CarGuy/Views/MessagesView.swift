//
//  MessagesView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 20/05/22.
//

import SwiftUI

struct MessagesView: View {
    @StateObject var messagesManager: MessagesViewModel
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(messagesManager.messages, id: \.id) { message in
                        MessageBubble(message: message)
                    }
                }.onChange(of: messagesManager.lastMessageId) { id in
                    withAnimation{
                        proxy.scrollTo(id, anchor: .bottom)
                    }
                }.onAppear{
                    withAnimation{
                        proxy.scrollTo(messagesManager.lastMessageId, anchor: .bottom)
                    }
                }
            }
            MessageTextField().environmentObject(messagesManager)
        }
    }
}
