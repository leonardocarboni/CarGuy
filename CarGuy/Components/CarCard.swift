//
//  CarCard.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 17/05/22.
//

import SwiftUI

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: 200)
                .clipped()
        }
    }
}

struct CarCard: View {
    
    @ObservedObject var imageLoader = ImageLoader()
    @ObservedObject var carsManager: CarsViewModel
    @State var carId: String
    
    var body: some View {
        if let carIndex = carsManager.cars.firstIndex(where: {$0.id == carId}) {
            NavigationLink(destination:
                            CarDetailsView(carManager: carsManager, carId: carId).navigationTitle(Text(carsManager.cars[carIndex].model))) {
                VStack {
                    if carsManager.cars[carIndex].imageUrl != nil && carsManager.cars[carIndex].imageUrl != "" {
                        ZStack{
                            Image(uiImage: imageLoader.image).centerCropped().frame(height: 200)
                                .onAppear {
                                    imageLoader.loadImage(url: URL(string: carsManager.cars[carIndex].imageUrl!)!)
                                }
                            CircleProgressView(isLoading: $imageLoader.isLoading)
                        }
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text (String(carsManager.cars[carIndex].year)).font(.headline).foregroundColor(.secondary).shadow(color: .black, radius: 1)
                            Text (carsManager.cars[carIndex].model).font(.title).fontWeight(.black).foregroundColor(.primary).lineLimit(1)
                            Text (carsManager.cars[carIndex].brand).font(.title3).foregroundColor(.secondary).shadow(color: .black, radius: 1)
                        }
                        .layoutPriority(100)
                        Spacer()
                    }
                    .padding ()
                }
                .background().clipShape(RoundedRectangle(cornerRadius: 20)).shadow(color: .gray, radius: 7, x: 2, y: 2)
                .padding([.top, .horizontal])
            }
            
        }
    }
}
