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

private var userCoords = CLLocationCoordinate2D(latitude: 43.96, longitude: 12.65)
private let userPos = CLLocation(latitude: userCoords.latitude, longitude: userCoords.longitude)

struct MeetsView: View {
    
    @StateObject var meetsManager = MeetsViewModel()
    
    var body: some View {
        List {
            Section(header: Text("Nelle vicinanze")) {
                ForEach(meetsManager.meets) { item in
                    let distance = userPos.distance(from: CLLocation(latitude: item.latitude, longitude: item.longitude))
                    if (distance < 200000) {
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
                    NavigationLink(destination: MeetDetailView(meetManager: meetsManager, meetId: event.id).navigationBarTitle(event.name)) {
                        VStack (alignment: .leading){
                            Text(event.name).font(.title2)
                            Text("\(event.city) - \(event.timestamp.getFormattedDate())").font(.subheadline)
                        }
                    }
                }
            }
        }.toolbar{
            NavigationLink(destination: AddMeetSheet(meetsManager: meetsManager).navigationBarTitle("Crea Raduno")) {
                Image(systemName: "plus.circle")
            }.foregroundColor(.primary)
        }
    }
    
}

struct MeetsView_Previews: PreviewProvider {
    static var previews: some View {
        MeetsView()
    }
}
