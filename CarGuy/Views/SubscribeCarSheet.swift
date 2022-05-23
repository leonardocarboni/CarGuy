//
//  SubscribeCarSheet.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 22/05/22.
//

import SwiftUI

struct SubscribeCarSheet: View {
    @Environment(\.dismiss) var dismiss
    
    let userDefaults = UserDefaults.standard
    @ObservedObject var meetManager: MeetsViewModel
    private var meetId: String
    @Binding var cars: [CarInGarage]
    
    @State private var selectedCar = ""
    init(meetManager: MeetsViewModel, meetId: String, cars: Binding<[CarInGarage]>) {
        self.meetManager = meetManager
        self.meetId = meetId
        self._cars = cars
    }
    
    var body: some View {
        VStack{
            if (cars.count > 0) {
                Form{
                    Picker("Le tue auto", selection: $selectedCar) {
                        ForEach(cars) { car in
                            if car.meets != nil {
                                if !car.meets!.contains(meetId) {
                                    Text(verbatim: "\(car.year) \(car.brand) \(car.model)").tag(car.id)
                                }
                            } else {
                                Text(verbatim: "\(car.year) \(car.brand) \(car.model)").tag(car.id)
                            }
                        }
                    }.pickerStyle(.inline)
                    Button(action: {
                        meetManager.subscribeCar(carId: selectedCar, meetId: meetId)
                        if let index = cars.firstIndex(where: {$0.id == selectedCar}) {
                            if cars[index].meets != nil {
                                cars[index].meets!.append(contentsOf: ["\(meetId)"])
                            } else {
                                cars[index].meets = ["\(meetId)"]
                            }
                        }
                        dismiss()
                    }) {
                        Text("Seleziona auto")
                    }.disabled(selectedCar == "")
                }
            } else {
                Text("Nessuna auto da iscrivere")
            }
        }
    }
}
