//
//  GarageView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 17/05/22.
//

import SwiftUI

struct GarageView: View {
    @StateObject var carsManager = CarsViewModel()
    var body: some View {
        ScrollView{
            HStack{
                Text("Il tuo garage").font(.title2).padding()
                Spacer()
                NavigationLink(destination: AddCarView(carManager: carsManager).navigationTitle(Text("Aggiungi Auto"))) {
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
            ForEach(carsManager.cars) {car in
                CarCard(carsManager: carsManager, carId: car.id)
            }
            Divider().padding()
        }
    }
}
