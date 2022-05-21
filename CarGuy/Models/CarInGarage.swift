//
//  CarInGarage.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 17/05/22.
//

import Foundation

struct CarInGarage: Identifiable{
    var id: String
    var brand: String
    var model: String
    var year: Int
    var imageUrl: String?
    var zero100secs: Float?
    var km: Int?
    var cc: Int?
    var cv: Int?
    var addTimestamp: Date
    
    init(id: String, brand: String, model: String, year: Int, addTimestamp: Date, imageUrl: String?=nil, zero100secs: Float?=nil, km: Int?=nil, cc: Int?=nil, cv: Int?=nil) {
        self.id = id
        self.brand = brand.capitalized
        self.model = model.capitalized
        self.year = year
        self.imageUrl = imageUrl
        self.addTimestamp = addTimestamp
        self.zero100secs = zero100secs
        self.km = km
        self.cv = cv
        self.cc = cc
    }
}
