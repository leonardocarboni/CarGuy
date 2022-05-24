//
//  LocationViewModel.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 23/05/22.
//

import MapKit

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 43.96, longitude: 12.65)
    static let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
}

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    
    @Published var authorizationAlert = false
    @Published var authorizationAlertText = ""
    
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.span)
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            
            //locationManagerDidChangeAuthorization viene chiamato automaticamente quando si istanzia un CLLocationManager
            locationManager!.delegate = self
            
        } else {
            authorizationAlertText = "Servizio di localizzazione disabilitato, attivalo per far funzionare correttamente l'app"
            authorizationAlert = true
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else {
            return
        }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            authorizationAlertText = "Accesso limitato alla posizione. Controlla le impostazioni di Parental Control."
            authorizationAlert = true
            print("Location Restricted")
        case .denied:
            authorizationAlertText = "Accesso alla posizione negato. Controlla le impostazioni di Privacy."
            authorizationAlert = true
            print("Location denied")
        case .authorizedAlways, .authorizedWhenInUse:
            //aggiornamento regione
            region = MKCoordinateRegion(center: locationManager.location?.coordinate ?? MapDetails.startingLocation, span: MapDetails.span)
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
