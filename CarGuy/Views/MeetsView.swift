//
//  MeetsView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 17/05/22.
//

import SwiftUI
import MapKit

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
    func getFormattedDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
}

struct MeetsView: View {
    
    @StateObject var meetsManager = MeetsViewModel()
    
    @StateObject var locationManager = LocationViewModel()
    
    var body: some View {
        List {
            Section(header: Text("Nelle vicinanze")) {
                ForEach(meetsManager.meets) { item in
                    let userPos = locationManager.locationManager == nil || locationManager.locationManager!.location == nil ? CLLocation(latitude: 43.96, longitude: 12.65) : locationManager.locationManager!.location!
                    let distance = userPos.distance(from: CLLocation(latitude: item.latitude, longitude: item.longitude))
                    if (distance < 200000 && item.timestamp > Date()) {
                        NavigationLink(destination: MeetDetailView(meetManager: meetsManager, meetId: item.id).navigationBarTitle(item.name)) {
                            VStack (alignment: .leading){
                                Text(item.name).font(.title2)
                                Text("\(item.city) - \(item.timestamp.getFormattedDate())").font(.subheadline)
                            }
                        }
                    }
                }
            }
            Section(header: Text("Tutti gli eventi")) {
                ForEach(meetsManager.meets) {event in
                    if event.timestamp > Date() {
                        NavigationLink(destination: MeetDetailView(meetManager: meetsManager, meetId: event.id).navigationBarTitle(event.name)) {
                            VStack (alignment: .leading){
                                Text(event.name).font(.title2)
                                Text("\(event.city) - \(event.timestamp.getFormattedDate())").font(.subheadline)
                            }
                        }
                    }
                }
            }
        }.toolbar{
            NavigationLink(destination: AddMeetView(meetsManager: meetsManager).navigationBarTitle("Crea Raduno")) {
                Image(systemName: "plus.circle")
            }.foregroundColor(.primary)
        }.onAppear{
            locationManager.checkIfLocationServicesIsEnabled()
        }
    }
    
}

struct MeetsView_Previews: PreviewProvider {
    static var previews: some View {
        MeetsView()
    }
}
