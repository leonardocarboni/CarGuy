//
//  LoadingView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 24/05/22.
//

import SwiftUI

/**
 View di caricamento
 */
struct LoadingView: View {
    @State var animation = false
    var body: some View {
        VStack{
            VStack{
                Circle().trim(from: 0, to: 0.7)
                    .stroke(.blue, lineWidth: 8)
                    .frame(width: 75, height: 75)
                    .rotationEffect(.init(degrees: animation ? 360 : 0))
                    .padding(50)
            }.background(.background).cornerRadius(20)
        }
        .onAppear(perform: {
            withAnimation(Animation.linear(duration: 1)){
                animation.toggle()
            }
        })
    }
}
