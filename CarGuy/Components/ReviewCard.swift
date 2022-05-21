//
//  ReviewCard.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 20/05/22.
//

import SwiftUI

struct ReviewCard: View {
    var review: Review
    
    var body: some View {
        HStack{
            if review.pfpUrl != "" {
                CircleImage(imageUrl: review.pfpUrl, diameter: 100).frame(width: 120)
            }
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

//
//struct ReviewCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewCard(review: Review(text: "Testo di prova", stars: 4, from: "Mauro", pfpUrl: "https://magazine.unibo.it/archivio/2018/inaugurato-il-nuovo-campus-di-cesena-allex-zuccherificio/cesena2.jpeg"))
//    }
//}
