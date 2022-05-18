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
    @ObservedObject var imageLoader = ImageLoader()
    
    var body: some View {
        ZStack {
            Image(uiImage: imageLoader.image).resizable().frame(width: diameter, height: diameter, alignment: .center).onAppear {
                imageLoader.loadImage(url: URL(string: imageUrl)!)
            }.clipShape(Circle()).overlay(Circle().stroke(Color.white, lineWidth: 4)).shadow(radius: 7)
            
            CircleProgressView(isLoading: $imageLoader.isLoading)
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
