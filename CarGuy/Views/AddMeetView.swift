//
//  AddMeetSheet.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 22/05/22.
//

import SwiftUI
import MapKit

struct AddMeetView: View {
    @Environment(\.presentationMode) var presentation
    
    @State var showSheet = false
    @State var showPlacePicker = false
    
    @ObservedObject var meetsManager: MeetsViewModel
    @StateObject var placeViewModel = PlacePickerViewModel()
    
    @State var name = ""
    @State var city = ""
    @State var date = Date()
    @State var image = UIImage()
    @State var place: Place?
    
    var body: some View {
        ZStack {
            VStack{
                
                Form {
                    Section(header: Text("Dettagli")){
                        TextField("Nome", text: $name)
                        TextField("Città", text: $city).keyboardType(.numberPad)
                        DatePicker(selection: $date, in: Date()..., displayedComponents: .date) {
                            Text("Data")
                        }
                        NavigationLink (destination: PlacePicker(placeViewModel: placeViewModel, selectedPlace: $place).navigationTitle("Posizione")) {Text(place != nil ? "\(place!.name)" : "Seleziona Posizione")}
                        Button(action: {
                            showSheet = true
                        }){Text("Seleziona Immagine")}
                        HStack {
                            Spacer()
                            Image(uiImage: self.image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .background(Color.black.opacity(0.2)).clipped()
                            Spacer()
                        }
                    }
                }
                Button(action: {
                    if name != "" && city != "" && place != nil {
                        meetsManager.addMeet(name: name, city: city, date: date, place: place!, presentation: presentation, image: image.size.width > 0 ? image : nil)
                    }
                }) {
                    Text("Crea Raduno")
                        .padding()
                        .frame(maxWidth: .infinity)
                }.background(Color.blue).foregroundColor(.white).clipShape(RoundedRectangle(cornerRadius: 10)).padding()
            }
            if meetsManager.uploading {
                LoadingView()
            }
        }.sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
    }
}
