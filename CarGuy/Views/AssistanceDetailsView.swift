//
//  AssistanceDetailsView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 24/05/22.
//

import SwiftUI

struct AssistanceDetailsView: View {
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var assistanceManager: AssistancesViewModel
    
    @State var openMessages = false
    @State var accepted = false
    
    var assistance: Assistance
    
    init(assistanceManager: AssistancesViewModel, assistance: Assistance) {
        self.assistanceManager = assistanceManager
        self.assistance = assistance
    }
    
    var body: some View {
        VStack {
            NavigationLink (destination: ProfileView(uid: assistance.creatorUid)){
                HStack {
                    Spacer()
                    if assistance.pfpUrl != "" {
                        CircleImage(imageUrl: assistance.pfpUrl, diameter: 100).frame(width: 120)
                    }
                    Text(assistance.name)
                    Spacer()
                }.padding()
            }
            
            HStack {
                Text(assistance.type).font(.headline)
                Spacer()
                Text("\(assistance.priceOffer) €")
            }.padding()
            HStack {
                Text("Descrizione").font(.headline)
                Spacer()
            }.padding()
            Text(assistance.description).padding()
            Spacer()
            HStack {
                Button(action: {
                    self.assistanceManager.acceptAssistance(assistanceId: assistance.id)
                    accepted = true
                }) {
                    Text("Accetta")
                        .padding()
                        .frame(maxWidth: .infinity)
                }.background(Color.blue).foregroundColor(.white).clipShape(RoundedRectangle(cornerRadius: 10)).padding()
                Button(action: {
                    let chatsManager = ChatsViewModel()
                    
                    if chatsManager.chats.contains(where: {$0.toId == assistance.creatorUid}) {
                        openMessages = true
                    } else {
                        chatsManager.createChat(toId: assistance.creatorUid, completed: $openMessages)
                    }
                }) {
                    Image(systemName: "paperplane")
                        .padding()
                        .frame(maxWidth: .infinity)
                }.background(Color.blue).foregroundColor(.white).clipShape(RoundedRectangle(cornerRadius: 10)).padding()
            }
        }
        .alert("Chat", isPresented: $openMessages, actions: {}, message: {
            Text("Controlla le chat dalla sezione garage per scrivere a questo utente.")
        })
        .alert("Assistenza", isPresented: $accepted, actions: {}, message: {
            Text("Hai accettato una richiesta di assistenza con successo.")
        })
    }
}
