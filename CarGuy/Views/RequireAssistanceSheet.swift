//
//  RequireAssistanceSheet.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 24/05/22.
//

import SwiftUI

struct RequireAssistanceSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var assistanceManager = AssistancesViewModel()
    @StateObject var placeViewModel = PlacePickerViewModel()
    
    var car: CarInGarage
    @State var assistanceType = ""
    @State var description = ""
    @State var priceOffer = ""
    @State var place: Place?
    
    @State var showLocationSheet = false
    @State var alertShown = false
    
    var body: some View {
        
        VStack{
            HStack{
                Button (action: {
                    dismiss()
                }) {
                    Text("Annulla")
                }
                Spacer()
            }.padding()
            
            Text("Richiedi assistenza").font(.title)
            
            Form{
                Section(header: Text("Dettagli")) {
                    TextField(text: $assistanceType){
                        Text("Tipo di assistenza")
                    }
                    TextField(text: $priceOffer){
                        Text("Prezzo offerto (€)")
                    }.keyboardType(.numberPad)
                }
                Section(header: Text("Descrizione")) {
                    TextEditor(text: $description)
                }
                Section (header: Text("Posizione")) {
                    Button (action: {
                        showLocationSheet.toggle()
                    }) {Text(place == nil || place!.name == "Posizione Attuale" ? "Seleziona Posizione" : "\(place!.name)")}
                    Button (action: {
                        place = Place(name: "Posizione Attuale", coords: placeViewModel.getCurrentCoords())
                    }) {Text("Usa Posizione Attuale")}
                }
            }.padding()
            
            Spacer()
            Button(action: {
                if assistanceType != "" && place != nil{
                    assistanceManager.addAssistance(car: car, assistanceType: assistanceType, description: description, priceOffer: Int(priceOffer) ?? 0, latitude: place!.latitude, longitude: place!.longitude)
                    dismiss();
                } else {
                    alertShown.toggle()
                }
            }) {
                Text("Richiedi Assistenza")
                    .padding()
                    .frame(maxWidth: .infinity)
            }.background(Color.blue).foregroundColor(.white).clipShape(RoundedRectangle(cornerRadius: 10)).padding()
            
        }.sheet(isPresented: $showLocationSheet) {
            PlacePicker(placeViewModel: placeViewModel, selectedPlace: $place)
        }.alert("Errore", isPresented: $alertShown, actions: {}, message: {
            Text("Devi inserire tipo e posizione dell'assistenza.")
        })
    }
}
