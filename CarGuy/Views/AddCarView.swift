//
//  AddCarView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 21/05/22.
//

import SwiftUI


struct AddCarView: View {
    //For automatic page dismiss
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var carManager: CarsManager
    @ObservedObject var fetch = FetchCars()
    @State private var selectedManufacturer = -1
    @State private var selectedCar: String?
    @State private var selectedYear = ""
    @State private var selectedHp = ""
    @State private var selectedCC = ""
    @State private var selectedKM = ""
    @State private var selected0100 = ""
    
    //Image
    @State private var image = UIImage()
    @State private var showSheet = false
    
    var body: some View {
        ZStack {
            VStack{
                
                Form {
                    Section(header: Text("Modello")){
                        Picker("Brand", selection: $selectedManufacturer) {
                            Text("Seleziona").tag(-1)
                            ForEach(fetch.manufacturerCars) { manufacturer in
                                Text(manufacturer.name.capitalized).tag(manufacturer.id as Int?)
                            }
                        }
                        Picker("Modello", selection: $selectedCar) {
                            Text("Seleziona").tag(nil as String?)
                            if (selectedManufacturer != -1) {
                                let cars = fetch.manufacturerCars.filter({$0.id == selectedManufacturer}).first!
                                ForEach(cars.carsProduced) { car in
                                    Text(car.model.capitalized).tag(car.model as String?)
                                }
                            }
                        }
                        TextField("Anno", text: $selectedYear).keyboardType(.numberPad)
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
                }
                Button(action: {
                    if let brand = fetch.manufacturerCars.filter({$0.id == selectedManufacturer}).first?.name {
                        if selectedCar != nil {
                            if let year = Int(selectedYear) {
                                carManager.addCar(brand: brand, model: selectedCar!, year: year, cv: Int(selectedHp) ?? nil, cc: Int(selectedCC) ?? nil, km: Int(selectedKM) ?? nil, zero100: Float(selected0100) ?? nil, image: image.size.width != 0 ? image : nil)
                                selectedManufacturer = -1
                                selectedCar = ""
                                selectedYear = ""
                                selectedHp = ""
                                selectedCC = ""
                                selectedKM = ""
                                selected0100 = ""
                                image = UIImage()
                                self.presentation.wrappedValue.dismiss()
                            }
                        }
                    }
                }) {
                    Text("Aggiungi al garage")
                        .padding()
                        .frame(maxWidth: .infinity)
                }.background(Color.blue).foregroundColor(.white).clipShape(RoundedRectangle(cornerRadius: 10)).padding()
            }
            if carManager.uploading {
                LoadingView()
            }
        }.sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
    }
}
