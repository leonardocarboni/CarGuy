//
//  MessagesView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 20/05/22.
//

import SwiftUI

struct MessagesView: View {
    @StateObject var messagesManager: MessagesManager
    
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
                    }
                }
//            }
            MessageTextField().environmentObject(messagesManager)
        }
    }
}

//struct MessagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessagesView()
//    }
//}
