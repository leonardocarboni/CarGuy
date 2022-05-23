//
//  EditCarView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 21/05/22.
//

import SwiftUI


struct EditCarView: View {
    //For automatic page dismiss
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var carManager: CarsViewModel
    @State private var selectedHp: String
    @State private var selectedCC: String
    @State private var selectedKM: String
    @State private var selected0100: String
    
    //Image
    @State private var image = UIImage()
    @State private var showSheet = false
    var carId: String
    private var carIndex: Int
    var parentPresentation: Binding<PresentationMode>
    
    init(carManager: CarsViewModel, carId: String, image: UIImage?, parentPresentation: Binding<PresentationMode>) {
        self.carManager = carManager
        self.carId = carId
        self.carIndex = carManager.cars.firstIndex(where: {$0.id == carId})!
        self.parentPresentation = parentPresentation
        _selected0100 = State(initialValue: carManager.cars[carIndex].zero100secs != nil ? "\(carManager.cars[carIndex].zero100secs!)" : "")
        _selectedKM = State(initialValue: carManager.cars[carIndex].km != nil ? "\(carManager.cars[carIndex].km!)" : "")
        _selectedCC = State(initialValue: carManager.cars[carIndex].cc != nil ? "\(carManager.cars[carIndex].cc!)" : "")
        _selectedHp = State(initialValue: carManager.cars[carIndex].cv != nil ? "\(carManager.cars[carIndex].cv!)" : "")
        
        _image = State(initialValue: image != nil ? image! : UIImage())
    }
    
    var body: some View {
        if carIndex < carManager.cars.count {
            ZStack {
                VStack{
                    
                    Form {
                        Section(header: Text("Modello")){
                            HStack{
                                Text("Brand")
                                Spacer()
                                Text("\(carManager.cars[carIndex].brand)")
                            }.padding()
                            HStack{
                                Text("Modello")
                                Spacer()
                                Text("\(carManager.cars[carIndex].model)")
                            }.padding()
                            HStack{
                                Text("Anno")
                                Spacer()
                                Text("\(carManager.cars[carIndex].year)")
                            }.padding()
                        }
                        Section(header: Text("Dettagli")){
                            TextField("Cavalli (cv)", text: $selectedHp).keyboardType(.numberPad)
                            TextField("Cilindrata (cc)", text: $selectedCC).keyboardType(.numberPad)
                            TextField("Km percorsi (km)", text: $selectedKM).keyboardType(.numberPad)
                            TextField("0-100 (sec)", text: $selected0100).keyboardType(.numbersAndPunctuation)
                            //SELETTORE IMMAGINE
                            Button(action: {
                                showSheet = true
                            }){Text("Seleziona Immagine")}
                            Image(uiImage: self.image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 150)
                                .background(Color.black.opacity(0.2))
                        }
                        Section() {
                            Button(action: {
                                self.carManager.updateCar(carId: self.carManager.cars[carIndex].id, km: selectedKM, cc: selectedCC, cv: selectedHp, zero100: selected0100, image: self.image.size.width > 0 ? self.image : nil)
                            }) {Text("Aggiorna")}
                            Button(role: .destructive, action: {
                                self.carManager.removeCar(carId: self.carManager.cars[carIndex].id, editPresentation: self.presentation, detailPresentation: self.parentPresentation)
                            }) {Text("Elimina Auto")}
                        }
                    }
                }
                if carManager.uploading {
                    LoadingView()
                }
            }.sheet(isPresented: $showSheet) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
        }
    }
}
