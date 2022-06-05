//
//  GuysView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 17/05/22.
//

import SwiftUI
import MapKit
import Firebase
struct GuysView: View {
    @StateObject var assistancesManager = AssistancesViewModel()
    @StateObject var locationManager = LocationViewModel()
    
    var body: some View {
        Map(coordinateRegion: $locationManager.region, showsUserLocation: true,  annotationItems: assistancesManager.assistances.filter({ !$0.completed && $0.creatorUid != Firebase.Auth.auth().currentUser?.uid })){ assist in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: assist.latitude, longitude: assist.longitude)) {
                MapPinView(assistanceManager: assistancesManager, assistanceId: assist.id).padding(.vertical, 60)
            }
        }.onAppear{
            locationManager.checkIfLocationServicesIsEnabled()
        }.alert("Errore di posizione", isPresented: $locationManager.authorizationAlert, actions: {}, message: {Text(locationManager.authorizationAlertText)})
    }
}

struct MapPinView: View {
    @State private var showDetails = true
    
    @ObservedObject var assistanceManager: AssistancesViewModel
    let assistanceId: String
    
    var assistance: Assistance
    
    init(assistanceManager: AssistancesViewModel, assistanceId: String) {
        self.assistanceManager = assistanceManager
        self.assistanceId = assistanceId
        self.assistance = assistanceManager.assistances.first(where: {$0.id == assistanceId})!
    }
    
    var body: some View {
        VStack (spacing: 0) {
            HStack {
                VStack {
                    Text(assistance.type).font(.body)
                    Text("\(assistance.priceOffer) €").font(.footnote)
                }.padding(5)
                NavigationLink(destination: AssistanceDetailsView(assistanceManager: assistanceManager, assistance: assistance).navigationTitle("\(assistance.type)")) {
                    Image(systemName: "chevron.forward.circle.fill").resizable().scaledToFit().frame(width: 25, height: 25)
                }
            }.padding().background(.background).cornerRadius(10).opacity(showDetails ? 0 : 1).padding(3)
            Image(systemName: "mappin.circle.fill").resizable().scaledToFit().frame(width: 40, height: 40).font(.headline).foregroundColor(.red).background(.white).cornerRadius(36)
            Image(systemName: "triangle.fill").resizable().scaledToFit().foregroundColor(.red).frame(width: 10, height: 10).rotationEffect(Angle(degrees: 180)).offset(y: -3)
        }.onTapGesture {
            withAnimation{
                showDetails.toggle()
            }
        }
    }
}
