//
//  CarCard.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 17/05/22.
//

import SwiftUI

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: 200)
                .clipped()
        }
    }
}

struct CarCard: View {
    
    @ObservedObject var imageLoader = ImageLoader()
    @State var car: CarInGarage
    // MARK: - Properties
    @State private var goToNewView: Bool = false
    
    var body: some View {
        NavigationLink(destination: CarDetailsView(car: self.$car).toolbar {
            Image(systemName: "ellipsis")
        }.navigationTitle(Text(car.model)).navigationBarTitleDisplayMode(.inline), isActive: self.$goToNewView) {
            VStack {
                if car.imageUrl != nil && car.imageUrl != "" {
                    ZStack{
                        Image(uiImage: imageLoader.image).centerCropped()
                            .onAppear {
                                imageLoader.loadImage(url: URL(string: car.imageUrl!)!)
                            }
                        CircleProgressView(isLoading: $imageLoader.isLoading)
                    }
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text (String(car.year)).font(.headline).foregroundColor(.secondary)
                        Text (car.model).font(.title).fontWeight(.black).foregroundColor(.primary).lineLimit(3)
                        Text (car.brand).font(.title3).foregroundColor(.secondary)
                    }
                    .layoutPriority(100)
                    Spacer()
                }
                .padding ()
            }
            .background().clipShape(RoundedRectangle(cornerRadius: 20)).shadow(color: .gray, radius: 7, x: 2, y: 2)
            .padding([.top, .horizontal])
        }
        
    }
}

struct CarCard_Previews: PreviewProvider {
    static var previews: some View {
        CarCard(car: CarInGarage(id: "1", brand: "Lamborghini", model: "Aventador SVJ", year: 2020, addTimestamp: Date(), imageUrl: "https://www.lamborghini.com/sites/it-en/files/DAM/lamborghini/facelift_2019/model_detail/huracan/tecnica/s/hura_tecnica_s_02a.jpg")).environment(\.colorScheme, .dark)
    }
}

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
