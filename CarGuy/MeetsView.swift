//
//  MeetsView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 17/05/22.
//

import SwiftUI
import MapKit

struct Event: Identifiable {
    let name: String
    let id = UUID()
    let coords: CLLocationCoordinate2D
    let date: Date
    let city: String
}

extension Date {
    init(_ dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "it_IT") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
    
    /**
     Returns the date in the format "dd/MM/yyyy"
     */
    func getDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
}

private var userCoords = CLLocationCoordinate2D(latitude: 43.96, longitude: 12.65)
private let userPos = CLLocation(latitude: userCoords.latitude, longitude: userCoords.longitude)

private var events = [
    Event(name: "\"Cesena Motori\" IIª edizione", coords: CLLocationCoordinate2D(latitude: 44.13, longitude: 12.23), date: Date("2022-06-11"), city: "Cesena"),
    Event(name: "Raduno \"LamBologna\"", coords: CLLocationCoordinate2D(latitude: 44.29, longitude: 11.20), date: Date("2022-06-24"), city: "Bologna"),
    Event(name: "\"Porsche Championship '22\"", coords: CLLocationCoordinate2D(latitude: 43.96, longitude: 12.68), date: Date("2022-07-02"), city: "Rimini"),
    Event(name: "\"Federico IIº\"", coords: CLLocationCoordinate2D(latitude: 40.88, longitude: 14.25), date: Date("2022-10-16"), city: "Napoli"),
    Event(name: "Arctic Monkeys Tribute", coords: CLLocationCoordinate2D(latitude: 39.95, longitude: 8.69), date: Date("2023-01-04"), city: "Oristano")
]

//private let userPos = CLLocationCoordinate2DMake(CLLocationDegrees(userCoords.latitude), CLLocationDegrees(userCoords.longitude))
//let request = MKDirections.Request()
//request.source = MKPlacemark(coordinate: userCoords)
//request.destination = MKPlacemark(coordinate: item.coords)
//request.transportType = MKDirectionsTransportType.automobile;

struct MeetsView: View {
    
    var body: some View {
        List {
            Section(header: Text("Nelle vicinanze")) {
                ForEach(events) { item in
                    let distance = userPos.distance(from: CLLocation(latitude: item.coords.latitude, longitude: item.coords.longitude))
                    //print(distance)
                    if (distance < 200000) {
                        VStack (alignment: .leading){
                            Text(item.name).font(.title2)
                            Text("\(item.city) - \(item.date.getDate())").font(.subheadline)
                        }
                    }
                }
            }
            Section(header: Text("Tutti gli eventi")) {
                ForEach(events) {event in
                    VStack (alignment: .leading){
                        Text(event.name).font(.title2)
                        Text("\(event.city) - \(event.date.getDate())").font(.subheadline)
                    }
                }
            }
        }
    }
    
}

struct MeetsView_Previews: PreviewProvider {
    static var previews: some View {
        MeetsView()
    }
}
