//
//  GuysView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 17/05/22.
//

import SwiftUI
import MapKit

struct GuysView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 44.13, longitude: 12.23), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    var body: some View {
        Map(coordinateRegion: $region)
    }
}

struct GuysView_Previews: PreviewProvider {
    static var previews: some View {
        GuysView()
    }
}
