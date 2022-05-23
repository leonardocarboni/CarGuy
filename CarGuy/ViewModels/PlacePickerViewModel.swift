//
//  PlacePickerViewModel.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 23/05/22.
//

import Foundation
import MapKit

class PlacePickerViewModel: ObservableObject {
    private let locationManager = CLLocationManager()
    private var searchDistance: Double = 10000
    private var defaultSearchCoordinates: CLLocationCoordinate2D?
    
    @Published var places: [Place] = []
    
    @Published var searchText = "" {
        didSet {
            if searchText.count > 2 {
                self.search(text: searchText)
            }
        }
    }
    
    private func search(text: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.pointOfInterestFilter = .includingAll
        request.resultTypes = .pointOfInterest
        
        if let currentCoordinate = locationManager.location?.coordinate {
            request.region = MKCoordinateRegion(center: currentCoordinate, latitudinalMeters: searchDistance, longitudinalMeters: searchDistance)
        } else if let defaultSearchCoordinates = defaultSearchCoordinates, CLLocationCoordinate2DIsValid(defaultSearchCoordinates) {
            request.region = MKCoordinateRegion(center: defaultSearchCoordinates, latitudinalMeters: searchDistance, longitudinalMeters: searchDistance)
        }
        
        MKLocalSearch(request: request).start { response, error in
            guard self.searchText == text else {
                return
            }
            
            if error != nil {
                self.places = []
                return
            }
            
            if response == nil {
                self.places = []
                return
            }
            
            if response!.mapItems.count < 1 {
                self.places = []
                return
            }
            
            self.places = []
            for mapItem in response!.mapItems {
                self.places.append(Place(mapItem: mapItem))
            }
        }
    }
}
