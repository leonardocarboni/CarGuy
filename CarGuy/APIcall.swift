//
//  APIcall.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 19/05/22.
//

import Foundation
import SwiftUI

struct Manufacturer: Codable, Identifiable {
    var num_models: Int
    var img_url: String
    var max_car_id: Int
    var id: Int
    var name: String
    var avg_horsepower: Float
    var avg_price: Float
    
    
}

struct Car: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case id, year, horsepower, make, model, price, img_url
    }
    
    var id: Int
    var year: Int
    var horsepower: Int
    var make: String
    var model: String
    var price: Int
    var img_url: String
    
    //    init(from decoder: Decoder) throws {
    //        let container = try decoder.container(keyedBy: CodingKeys.self)
    //        self.id = try container.decode(Int.self, forKey: .id)
    //        self.year = try container.decode(Int.self, forKey: .year)
    //        self.horsepower = try container.decode(Int.self, forKey: .horsepower)
    //        self.model = try container.decode(String.self, forKey: .model)
    //        self.price = try container.decode(Int.self, forKey: .price)
    //        self.img_url = try container.decode(String.self, forKey: .img_url)
    //        self.make = try container.decode(Manufacturer.self, forKey: .make)
    //      }
}

struct ManufacturerCars : Codable, Identifiable {
    var num_models: Int
    var img_url: String
    var max_car_id: Int
    var id: Int
    var name: String
    var avg_horsepower: Float
    var avg_price: Float
    var carsProduced: [Car]
}

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
                    } catch {}
                }
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



