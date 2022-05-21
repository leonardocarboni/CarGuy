//
//  Car.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 20/05/22.
//

import Foundation

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
    var id: Int
    var year: Int
    var horsepower: Int
    var make: String
    var model: String
    var price: Int
    var img_url: String
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
