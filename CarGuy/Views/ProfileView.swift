//
//  ExploreView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 17/05/22.
//

import SwiftUI

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
                    if userModel.avgStars != nil {
                        Text(String(format: "%.1f", userModel.avgStars!)).font(.title).bold()
                    } else {
                        Text("N.D").font(.title).bold()
                    }
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
