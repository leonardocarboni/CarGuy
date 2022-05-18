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
        GarageView()
    }
}

struct AddCarView: View {
    
    @State private var selectedStrength: String?
    let strengths = ["Audi", "BMW", "Mercedes Benz"]
    
    var body: some View {
        
        Form {
            Section{
                Picker("Brand", selection: $selectedStrength) {
                    Text("Seleziona").tag(nil as String?)
                    ForEach(strengths, id: \.self) {
                        Text($0).tag($0 as String?)
                    }
                }
            }
            
        }
    }
}
