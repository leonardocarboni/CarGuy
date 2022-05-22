//
//  APIcall.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 19/05/22.
//

import Foundation
import SwiftUI

class FetchCars: ObservableObject {
    @Published var manufacturers = [Manufacturer]()
    @Published var cars = [Car]()
    @Published var manufacturerCars = [ManufacturerCars]()
    
    init() {
        let urlM = URL(string: "https://private-anon-bfeb6e78bf-carsapi1.apiary-mock.com/manufacturers")!
        let requestM = URLRequest(url: urlM)
        let taskM = URLSession.shared.dataTask(with: requestM) { data, response, error in
            if response != nil {
                if let data = data, let _ = String(data: data, encoding: .utf8) {
                    let decoder = JSONDecoder()
                    
                    do {
                        self.manufacturers = try decoder.decode([Manufacturer].self, from: data)
                    } catch {
                        print("Couldn't decode car manufacturers")
                    }
                } else {
                    print("Couldn't decode car manufacturers")
                }
            } else {
                print("Empty response for car manufacturers")
            }
        }
        
        taskM.resume()
        
        let urlC = URL(string: "https://private-anon-bfeb6e78bf-carsapi1.apiary-mock.com/cars")!
        let requestC = URLRequest(url: urlC)
        let taskC = URLSession.shared.dataTask(with: requestC) { data, response, error in
            if response != nil {
                if let data = data, let _ = String(data: data, encoding: .utf8) {
                    let decoder = JSONDecoder()
                    
                    do {
                        self.cars = try decoder.decode([Car].self, from: data)
                        for man in self.manufacturers {
                            var carsProduced: [Car] = []
                            for c in self.cars {
                                if c.make == man.name {
                                    carsProduced.append(c)
                                }
                            }
                            let new = ManufacturerCars(num_models: man.num_models, img_url: man.img_url, max_car_id: man.max_car_id, id: man.id, name: man.name, avg_horsepower: man.avg_horsepower, avg_price: man.avg_price, carsProduced: carsProduced)
                            self.manufacturerCars.append(new)
                        }
                        self.manufacturerCars.sort(by: { $0.id > $1.id })
                    } catch {}
                }
            }
        }
        
        taskC.resume()
    }
}



