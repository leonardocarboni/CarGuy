//
//  CircleImage.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 18/05/22.
//

import SwiftUI

struct CircleImage: View {
    var imageUrl: String
    var diameter: CGFloat
    var shadowRadius = 4.0
    
    var body: some View {
        ZStack {
            if imageUrl != "" {
                AsyncImage(
                    url: URL(string: imageUrl)!,
                    content: { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(maxWidth: diameter, maxHeight: diameter)
                    },
                    placeholder: {
                        ProgressView()
                    }
                ).clipShape(Circle()).overlay(Circle().stroke(Color.white, lineWidth: 2)).shadow(radius: shadowRadius)
            }
        }
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(imageUrl: "https://magazine.unibo.it/archivio/2018/inaugurato-il-nuovo-campus-di-cesena-allex-zuccherificio/cesena2.jpeg", diameter: 150)
    }
}

struct CircleProgressView: View {
    @Binding var isLoading: Bool
    
    var body: some View {
        if isLoading {
            ProgressView()
        }
    }
}
