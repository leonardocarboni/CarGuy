//
//  ChatsView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 20/05/22.
//

import SwiftUI

struct ChatsView: View {
    @StateObject var chatsManager = ChatsManager()
    var body: some View {
        
        ScrollView{
            ForEach(chatsManager.chats, id: \.self) {chat in
                NavigationLink(destination: MessagesView(messagesManager: chat.messagesManager).navigationTitle(chat.toName)){
                    HStack {
                        CircleImage(imageUrl: "https://images.unsplash.com/photo-1616767709128-073bb5c6503d?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=60&raw_url=true&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDJ8dG93SlpGc2twR2d8fGVufDB8fHx8&auto=format&fit=crop&w=500", diameter: 50, shadowRadius: 0).padding()
                        VStack (alignment: .leading){
                            Text(chat.toName).font(.title3).bold()
//                            Text(chat.messagesManager.messages.last!.text).lineLimit(1).font(.body)
                        }
                        Spacer()
                        Image(systemName: "chevron.forward.circle.fill").resizable().scaledToFit().frame(width: 30, height: 30).padding()
                    }.frame(maxWidth: .infinity, alignment: .center)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .gray, radius: 3, x: 2, y: 2).padding(.vertical, 8).padding(.horizontal)
                }.foregroundColor(.primary)
            }
        }
        
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView()
    }
}
