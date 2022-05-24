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
    @ObservedObject var carManager: CarsViewModel
    var carId: String
    @State private var showingSheet = false
    @State var editing = false
    @State var meets: [Meet]
    
    init(carManager: CarsViewModel, carId: String) {
        self.carManager = carManager
        self.carId = carId
        let userDefaults = UserDefaults.standard
        if let meetsData = userDefaults.object(forKey: "meets") as? Data {
            do {
                _meets = try State(initialValue: JSONDecoder().decode([Meet].self, from: meetsData))
            } catch {
                _meets = State(initialValue: [Meet]())
            }
        } else {
            _meets = State(initialValue: [Meet]())
        }
    }
    
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
                            RequireAssistanceSheet(car: carManager.cars[carIndex])
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
                    
                    Text("Raduni").font(.headline)
                    VStack {
                        if carManager.cars[carIndex].meets != nil {
                            if carManager.cars[carIndex].meets!.count > 0 {
                                ForEach(carManager.cars[carIndex].meets!, id: \.self) { meet in
                                    if let meetIndex = meets.firstIndex(where: {$0.id == meet}){
                                        HStack {
                                            Text("\(meets[meetIndex].name)")
                                            Spacer()
                                            Text("\(meets[meetIndex].timestamp.getFormattedDate())")
                                        }.padding([.top, .horizontal])
                                    }
                                }
                            } else {
                                HStack{
                                    Spacer()
                                    Text("Nessun raduno")
                                    Spacer()
                                }
                            }
                            
                        } else {
                            HStack{
                                Spacer()
                                Text("Nessun raduno")
                                Spacer()
                            }
                        }
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
