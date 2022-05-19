//
//  ContentView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 17/05/22.
//

import SwiftUI

private var carsInGarage = [
    CarInGarage(brand: "Lamborghini", model: "Aventador SVJ", year: 2019, imageUrl: "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/lamborghini-aventador-svj-01-1536325819.jpg?crop=1.00xw:0.753xh;0,0.0929xh&resize=1200:*"),
    CarInGarage(brand: "Nissan", model: "Patrol", year: 2018, imageUrl: "https://cdn.motor1.com/images/mgl/rMyGx/s1/2022-nissan-patrol-nismo-facelift.jpg"),
    CarInGarage(brand: "Ferrari", model: "Testarossa", year: 1984, imageUrl: "https://ruoteclassiche.quattroruote.it/wp-content/uploads/2020/09/cover-ferrari-testarossa-2.jpg")
]

struct GarageView: View {
    var body: some View {
        ScrollView{
            HStack{
                Text("Il tuo garage").font(.title2).padding()
                Spacer()
                NavigationLink(destination: AddCarView().navigationTitle(Text("Aggiungi Auto"))) {
                    HStack{
                        Text("Aggiungi").font(.subheadline)
                        Spacer()
                        Image(systemName: "plus")
                    }.frame(width: 100, height: 10)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
            }.padding()
            ForEach(carsInGarage) {car in
                CarCard(car: car)
            }
            Divider().padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AddCarView()
    }
}

struct AddCarView: View {
    @ObservedObject var fetch = FetchCars()
    @State private var selectedManufacturer: Int?
    @State private var selectedCar: String?
    
    var body: some View {
        VStack{
            Form {
                Section{
                    Picker("Brand", selection: $selectedManufacturer) {
                        Text("Seleziona").tag(nil as String?)
                        ForEach(fetch.manufacturerCars) { manufacturer in
                            Text(manufacturer.name.capitalized).tag(manufacturer.id as Int?)
                        }
                    }
                    Picker("Modello", selection: $selectedCar) {
                        Text("Seleziona").tag(nil as String?)
                        if selectedManufacturer != nil {
                            let cars = fetch.manufacturerCars.filter({$0.id == selectedManufacturer!}).first!
                            ForEach(cars.carsProduced) { car in
                                Text(car.model.capitalized).tag(car.model as String?)
                            }
                        } else {
                            
                        }
                    }
                }
            }.onAppear {
                UITableView.appearance().backgroundColor = .systemBackground
             }.padding()
            
            Button(action: {}) {
                Text("Aggiungi al garage")
                    .padding()
                    .frame(maxWidth: .infinity)
            }.background(Color.blue).foregroundColor(.white).clipShape(RoundedRectangle(cornerRadius: 10)).padding()
        }
    }
}

