//
//  ExploreView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 17/05/22.
//

import SwiftUI
import MapKit

struct Review: Identifiable {
    let id = UUID()
    let text : String
    let stars: Int
    let from: String
    let pfpUrl: String
}


private var reviews = [
    Review(text: "Detailing fantastico, ma si fa pagare troppo", stars: 4, from: "Maurizio Marri", pfpUrl: "https://magazine.unibo.it/archivio/2018/inaugurato-il-nuovo-campus-di-cesena-allex-zuccherificio/cesena2.jpeg"),
    Review(text: "Fantastico e davvero professionale, uno dei migliori nella zona di Napoli", stars: 5, from: "Maurizio Marri", pfpUrl: "https://magazine.unibo.it/archivio/2018/inaugurato-il-nuovo-campus-di-cesena-allex-zuccherificio/cesena2.jpeg"),
    Review(text: "Fantastico e davvero professionale", stars: 5, from: "Maurizio Marri", pfpUrl: "https://magazine.unibo.it/archivio/2018/inaugurato-il-nuovo-campus-di-cesena-allex-zuccherificio/cesena2.jpeg"),
    Review(text: "Fantastico e davvero professionale", stars: 3, from: "Maurizio Marri", pfpUrl: "https://magazine.unibo.it/archivio/2018/inaugurato-il-nuovo-campus-di-cesena-allex-zuccherificio/cesena2.jpeg"),
]

struct ProfileView: View {
    var body: some View {
        ScrollView{
            HStack{
                CircleImage(imageUrl: "https://magazine.unibo.it/archivio/2018/inaugurato-il-nuovo-campus-di-cesena-allex-zuccherificio/cesena2.jpeg", diameter: 130).padding()
                VStack{
                    Text("Leonardo Carboni").font(.title)
                    
                }
            }
            HStack{
                VStack{
                    Text("3").font(.title).bold()
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
            
            
            ForEach(reviews) {rev in
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


struct ReviewCard: View {
    var review: Review
    
    var body: some View {
        HStack{
            CircleImage(imageUrl: review.pfpUrl, diameter: 100).frame(width: 120)
            VStack(alignment: .leading, spacing: 10) {
                Text(review.from).font(.system(size: 26, weight: .bold, design: .default))
                Text(review.text).font(.body)
                Rating(rating: review.stars)
            }.padding()
            Spacer()
        }.frame(maxWidth: .infinity, alignment: .center)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .gray, radius: 3, x: 2, y: 2).padding()
            
    }
}


struct Rating: View {
    var rating: Int
    
    var label = ""
    
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
            }
        }
    }
}
