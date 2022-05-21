//
//  MessageTextField.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 20/05/22.
//

import SwiftUI

struct MessageTextField: View {
    @EnvironmentObject var messagesManager: MessagesManager
    @State private var message = ""
    
    var body: some View {
        HStack {
            CustomTextField(placeholder: Text("Scrivi un messaggio..."), text: $message)
            Button (action: {
                if (message != "") {
                    messagesManager.sendMessage(text: message)
                    message = ""
                }
            }){
                Image(systemName: "paperplane.fill").padding().foregroundColor(.white).background(message == "" ? .gray : .blue).cornerRadius(100)
            }
        }.padding()
    }
}

//struct DMTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageTextField().environmentObject(MessagesManager())
//    }
//}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var commit: () -> () = {}
    
    var body: some View {
        ZStack (alignment: .leading){
            if text.isEmpty {
                placeholder.opacity(0.5)
            }
            
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}
