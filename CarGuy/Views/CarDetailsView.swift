//
//  CarDetailsView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 21/05/22.
//

import SwiftUI

struct CarDetailsView: View {
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var imageLoader = ImageLoader()
    @ObservedObject var carManager: CarsManager
    var carId: String
    @State private var showingSheet = false
    @State var editing = false
    
    var body: some View {
        
        if let carIndex = carManager.cars.firstIndex(where: {$0.id == carId}) {
            ScrollView{
                if carManager.cars[carIndex].imageUrl != nil && carManager.cars[carIndex].imageUrl != "" {
                    ZStack{
                        Image(uiImage: imageLoader.image).resizable().scaledToFill().frame(height: 200).clipped()
                            .onAppear {
                                imageLoader.loadImage(url: URL(string: carManager.cars[carIndex].imageUrl!)!)
                            }
                        CircleProgressView(isLoading: $imageLoader.isLoading)
                    }
                }
                VStack (alignment: .leading){
                    HStack{
                        Text(carManager.cars[carIndex].brand).font(.title3)
                        Spacer()
                        Text(String(carManager.cars[carIndex].year)).font(.headline)
                    }
                    Text(carManager.cars[carIndex].model).font(.title)
                    
                    Button(action: {
                        showingSheet.toggle()
                    }) {
                        Text("Richiedi Assistenza")
                            .padding()
                            .frame(maxWidth: .infinity)
                        
                    }.background(Color.blue).foregroundColor(.white).clipShape(RoundedRectangle(cornerRadius: 10)).padding()
                        .sheet(isPresented: $showingSheet) {
                            //RequireAssistanceSheet(car: self.$carManager.cars[carIndex])
                        }
                    
                    Text("Scheda Tecnica").font(.headline)
                    VStack{
                        HStack{
                            Text("Cavalli (kW)")
                            Spacer()
                            Text(carManager.cars[carIndex].cv == nil ? "N.D." : "\(carManager.cars[carIndex].cv!) cv")
                        }.padding([.top, .horizontal])
                        HStack{
                            Text("Cilindrata")
                            Spacer()
                            Text(carManager.cars[carIndex].cc == nil ? "N.D." : "\(carManager.cars[carIndex].cc!) cc")
                        }.padding([.top, .horizontal])
                        HStack{
                            Text("1-100 km/h")
                            Spacer()
                            Text(carManager.cars[carIndex].zero100secs == nil ? "N.D." : "\(carManager.cars[carIndex].zero100secs!) sec")
                        }.padding()
                        HStack{
                            Text("Km all'attivo")
                            Spacer()
                            Text(carManager.cars[carIndex].km == nil ? "N.D." : "\(carManager.cars[carIndex].km!) km")
                        }.padding()
                    }
                    
                    Text("Raduni a cui ha partecipato").font(.headline)
                    VStack {
                        HStack{
                            Text("Raduno Pesaro)")
                            Spacer()
                            Text("2020-10-18")
                        }.padding([.top, .horizontal])
                        HStack{
                            Text("Raduno Milano")
                            Spacer()
                            Text("2021-03-10")
                        }.padding([.top, .horizontal])
                    }
                    
                }.padding()
            }.toolbar {
                NavigationLink(destination: EditCarView(carManager: carManager, carId: carId, image: imageLoader.image, parentPresentation: presentation)){
                    Image(systemName: "square.and.pencil")
                }.foregroundColor(.primary)
            }
        }
    }
}


struct RequireAssistanceSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var car: CarInGarage
    
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
            
            Text("Richiedi assistenza")
            Spacer()
            Button(action: {}) {
                Text("Richiedi Assistenza")
                    .padding()
                    .frame(maxWidth: .infinity)
            }.background(Color.blue).foregroundColor(.white).clipShape(RoundedRectangle(cornerRadius: 10)).padding()
            
        }
        //TODO: FIX DARK MODE
    }
}
//
//struct CarDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CarDetailsView(car: CarInGarage(id: "0", brand: "Test", model: "Sample", year: 123, addTimestamp: Date()))
//    }
//}
