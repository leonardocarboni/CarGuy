//
//  ChatsView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 20/05/22.
//

import SwiftUI

struct ChatsView: View {
    @StateObject var chatsManager = ChatsViewModel()
    var body: some View {
        
        ScrollView{
            ForEach(chatsManager.chats, id: \.self) {chat in
                NavigationLink(destination: MessagesView(messagesManager: chat.messagesManager).navigationTitle(chat.toName).toolbar{
                    NavigationLink (destination: ProfileView(uid: chat.toId)){
                        Image(systemName: "person")
                    }
                }){
                    HStack {
                        if chat.toPfpUrl != "" {
                            CircleImage(imageUrl: chat.toPfpUrl, diameter: 50, shadowRadius: 0).padding()
                        }
                        VStack (alignment: .leading){
                            Text(chat.toName).font(.title3).bold()
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
