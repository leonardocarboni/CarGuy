//
//  PlacePicker.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 23/05/22.
//

import SwiftUI

struct PlacePicker: View {
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var placeViewModel: PlacePickerViewModel
    @Binding var selectedPlace: Place?
    
    var body: some View {
        Form {
            TextField(text: $placeViewModel.searchText){
                Text("Posizione")
            }
            Picker ("Posizione", selection: $selectedPlace) {
                ForEach(placeViewModel.places, id: \.self) { place in
                    Text(place.name).tag(place).onTapGesture {
                        selectedPlace = place
                        presentation.wrappedValue.dismiss()
                    }
                }
            }.pickerStyle(.inline)
        }
    }
}
