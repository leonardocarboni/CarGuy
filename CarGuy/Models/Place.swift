//
//  Place.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 23/05/22.
//

import Foundation
import MapKit

struct Place: Hashable {
    
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(mapItem: MKMapItem){
        self.name = mapItem.name!
        self.latitude = mapItem.placemark.coordinate.latitude
        self.longitude = mapItem.placemark.coordinate.longitude
    }
    
    init(name: String, coords: CLLocationCoordinate2D) {
        self.name = name
        self.latitude = coords.latitude
        self.longitude = coords.longitude
    }
    
}
