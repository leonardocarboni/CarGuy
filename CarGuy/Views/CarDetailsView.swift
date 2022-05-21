//
//  CarDetailsView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 21/05/22.
//

import SwiftUI

struct CarDetailsView: View {
    @ObservedObject var imageLoader = ImageLoader()
    @Binding var car: CarInGarage
    @State private var showingSheet = false
    
    var body: some View {
        ScrollView{
            if car.imageUrl != nil && car.imageUrl != "" {
                ZStack{
                    Image(uiImage: imageLoader.image).resizable().scaledToFill().frame(height: 200).clipped()
                        .onAppear {
                            imageLoader.loadImage(url: URL(string: car.imageUrl!)!)
                        }
                    CircleProgressView(isLoading: $imageLoader.isLoading)
                }
            }
            VStack (alignment: .leading){
                HStack{
                    Text(car.brand).font(.title3)
                    Spacer()
                    Text(String(car.year)).font(.headline)
                }
                Text(car.model).font(.title)
                
                Button(action: {
                    showingSheet.toggle()
                }) {
                    Text("Richiedi Assistenza")
                        .padding()
                        .frame(maxWidth: .infinity)
                    
                }.background(Color.blue).foregroundColor(.white).clipShape(RoundedRectangle(cornerRadius: 10)).padding()
                    .sheet(isPresented: $showingSheet) {
                        RequireAssistanceSheet(car: self.$car)
                    }
                
                Text("Scheda Tecnica").font(.headline)
                VStack{
                    HStack{
                        Text("Cavalli (kW)")
                        Spacer()
                        Text(car.cv == nil ? "N.D." : "\(car.cv!) cv")
                    }.padding([.top, .horizontal])
                    HStack{
                        Text("Cilindrata")
                        Spacer()
                        Text(car.cc == nil ? "N.D." : "\(car.cc!) cc")
                    }.padding([.top, .horizontal])
                    HStack{
                        Text("1-100 km/h")
                        Spacer()
                        Text(car.zero100secs == nil ? "N.D." : "\(car.zero100secs!) sec")
                    }.padding()
                    HStack{
                        Text("Km all'attivo")
                        Spacer()
                        Text(car.km == nil ? "N.D." : "\(car.km!) km")
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

struct CarDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CarDetailsView()
    }
}
