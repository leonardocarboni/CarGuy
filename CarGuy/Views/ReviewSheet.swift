//
//  ReviewSheet.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 24/05/22.
//

import SwiftUI

struct ReviewSheet: View {
    
    @Environment(\.presentationMode) var presentation
    
    @State var description = ""
    @State var stars = 1
    
    @ObservedObject var userManager: UserViewModel
    var uid: String
    
    var body: some View {
        Form {
            Picker("Select", selection: $stars) {
                Text("1").tag(1)
                Text("2").tag(2)
                Text("3").tag(3)
                Text("4").tag(4)
                Text("5").tag(5)
            }.pickerStyle(.segmented)
            Section(header: Text("Descrizione")) {
                TextEditor(text: $description)
            }
            Button(action: {
                userManager.addReview(description: description, stars: stars, toUid: uid)
                presentation.wrappedValue.dismiss()
                
            }) {
                Text("Pubblica Recensione")
            }
        }.padding()
    }
}
