//
//  MeetDetailView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 22/05/22.
//

import SwiftUI
import MapKit

struct MeetDetailView: View {
    @ObservedObject var meetManager: MeetsViewModel
    @State var region: MKCoordinateRegion
    @State var showingSubscriptionSheet = false
    var meetIndex: Int
    var meetId: String
    @State var cars: [CarInGarage]
    
    init(meetManager: MeetsViewModel, meetId: String) {
        self.meetManager = meetManager
        self.meetId = meetId
        self.meetIndex = meetManager.meets.firstIndex(where: {$0.id == meetId})!
        _region = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: meetManager.meets[meetIndex].latitude, longitude: meetManager.meets[meetIndex].longitude) , span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        let userDefaults = UserDefaults.standard
        if let carsData = userDefaults.object(forKey: "carsInGarage") as? Data {
            do {
                _cars = try State(initialValue: JSONDecoder().decode([CarInGarage].self, from: carsData))
            } catch {
                _cars = State(initialValue: [CarInGarage]())
            }
        } else {
            _cars = State(initialValue: [CarInGarage]())
        }
    }
    
    var body: some View {
        //        VStack{
        ScrollView{
            Map(coordinateRegion: $region, annotationItems: [meetManager.meets[meetIndex]]){
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
            }.frame(height: 300)
            
            if meetManager.meets[meetIndex].imageUrl != nil {
                CircleImage(imageUrl: meetManager.meets[meetIndex].imageUrl!, diameter: 100, shadowRadius: 7).offset(y: -30).padding(.bottom, -30)
            }
            
            Text(meetManager.meets[meetIndex].name).font(.title).bold()
            
            HStack{
                Text(meetManager.meets[meetIndex].city).font(.headline)
                Spacer()
                Text(meetManager.meets[meetIndex].timestamp.getFormattedDate()).font(.headline)
            }.padding()
            
            HStack {
                Text("Partecipanti già confermati: ").font(.headline)
                Spacer()
                Text("\(meetManager.meets[meetIndex].partecipantUids.count)").font(.headline)
            }.padding()
            
            HStack {
                Text("Le tue auto iscritte:")
                Spacer()
            }.padding()
            
            if cars.count > 0 {
                
                ForEach(cars) { car in
                    if car.meets != nil {
                        if car.meets!.contains("\(meetId)") {
                            HStack{
                                Text(verbatim: "\(car.year) \(car.brand) \(car.model)")
                                Spacer()
                                Button(action: {
                                    meetManager.removeCar(carId: car.id, meetId: meetId)
                                    if let carIndex = cars.firstIndex(where: {$0.id == car.id}) {
                                        if let meetIndex = cars[carIndex].meets!.firstIndex(where: {$0 == meetId}) {
                                            cars[carIndex].meets!.remove(at: meetIndex)
                                        }
                                        
                                    }
                                }) {
                                    Image(systemName: "xmark.circle")
                                }.foregroundColor(.red)
                            }.padding()
                        }
                    }
                }
            } else {
                HStack{
                    Text("Nessuna auto iscritta")
                    Spacer()
                }.padding()
            }
            Button(action: {
                showingSubscriptionSheet.toggle()
            }) {
                Text("Iscrivi un'auto")
                    .padding()
                    .frame(maxWidth: .infinity)
                
            }.background(Color.blue).foregroundColor(.white).clipShape(RoundedRectangle(cornerRadius: 10)).padding()
            //        }
        }.sheet(isPresented: $showingSubscriptionSheet) {
            SubscribeCarSheet(meetManager: meetManager, meetId: meetId, cars: $cars)
        }
    }
}
