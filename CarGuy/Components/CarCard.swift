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
    @State var car: CarInGarage
    @State private var goToNewView: Bool = false
    
    var body: some View {
        NavigationLink(destination: CarDetailsView(car: self.$car).toolbar {
            Image(systemName: "ellipsis")
        }.navigationTitle(Text(car.model)).navigationBarTitleDisplayMode(.inline), isActive: self.$goToNewView) {
            VStack {
                if car.imageUrl != nil && car.imageUrl != "" {
                    ZStack{
                        Image(uiImage: imageLoader.image).centerCropped()
                            .onAppear {
                                imageLoader.loadImage(url: URL(string: car.imageUrl!)!)
                            }
                        CircleProgressView(isLoading: $imageLoader.isLoading)
                    }
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text (String(car.year)).font(.headline).foregroundColor(.secondary).shadow(color: .black, radius: 1)
                        Text (car.model).font(.title).fontWeight(.black).foregroundColor(.primary).lineLimit(1).shadow(color: .black, radius: 2)
                        Text (car.brand).font(.title3).foregroundColor(.secondary).shadow(color: .black, radius: 1)
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

struct CarCard_Previews: PreviewProvider {
    static var previews: some View {
        CarCard(car: CarInGarage(id: "1", brand: "Lamborghini", model: "Aventador SVJ", year: 2020, addTimestamp: Date(), imageUrl: "https://www.lamborghini.com/sites/it-en/files/DAM/lamborghini/facelift_2019/model_detail/huracan/tecnica/s/hura_tecnica_s_02a.jpg")).environment(\.colorScheme, .dark)
    }
}
