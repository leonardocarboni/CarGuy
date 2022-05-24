//
//  ImageLoader.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 24/05/22.
//

import Foundation
import SwiftUI

class ImageLoader : ObservableObject{
    @Published var image = UIImage()
    @Published var isLoading = true
    
    func loadImage(imageName:String) {
        image = UIImage(named: imageName)!
        isLoading = false
    }
    
    func loadImage(url:URL) {
        DispatchQueue.global(qos: .background).async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                if let imageData = data {
                    self.image = UIImage(data: imageData)!
                    self.isLoading = false
                }
            }
        }
    }
}
