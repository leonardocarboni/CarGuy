//
//  ExploreView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 17/05/22.
//

import SwiftUI
import MapKit

//private var reviews = [
//    Review(text: "Detailing fantastico, ma si fa pagare troppo", stars: 4, from: "Maurizio Marri", pfpUrl: "https://magazine.unibo.it/archivio/2018/inaugurato-il-nuovo-campus-di-cesena-allex-zuccherificio/cesena2.jpeg"),
//    Review(text: "Fantastico e davvero professionale, uno dei migliori nella zona di Napoli", stars: 5, from: "Maurizio Marri", pfpUrl: "https://magazine.unibo.it/archivio/2018/inaugurato-il-nuovo-campus-di-cesena-allex-zuccherificio/cesena2.jpeg"),
//    Review(text: "Fantastico e davvero professionale", stars: 5, from: "Maurizio Marri", pfpUrl: "https://magazine.unibo.it/archivio/2018/inaugurato-il-nuovo-campus-di-cesena-allex-zuccherificio/cesena2.jpeg"),
//    Review(text: "Fantastico e davvero professionale", stars: 3, from: "Maurizio Marri", pfpUrl: "https://magazine.unibo.it/archivio/2018/inaugurato-il-nuovo-campus-di-cesena-allex-zuccherificio/cesena2.jpeg"),
//]

struct ProfileView: View {
    @StateObject var userModel = UserModel()
    
    var body: some View {
        ScrollView{
            HStack{
                if userModel.pfpUrl != "" {
                    CircleImage(imageUrl: userModel.pfpUrl, diameter: 130, shadowRadius: 7).padding()
                }
                VStack{
                    Text(userModel.name).font(.title)
                }
            }
            HStack{
                VStack{
                    Text(String(userModel.nCars)).font(.title).bold()
                    Text("Auto")
                }.frame(minWidth: 0, maxWidth: .infinity)
                VStack{
                    Text("5").font(.title).bold()
                    Text("Assistenze")
                }.frame(minWidth: 0, maxWidth: .infinity)
                VStack{
                    Text("4.5").font(.title).bold()
                    Text("Stelle")
                }.frame(minWidth: 0, maxWidth: .infinity)
            }.padding()
            
            
            ForEach(userModel.reviews) {rev in
                ReviewCard(review: rev)
            }
            
            
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
