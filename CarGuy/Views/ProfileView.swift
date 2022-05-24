//
//  ExploreView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 17/05/22.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var userModel: UserViewModel
    
    @State var editing = false
    @State var editPfp = false
    @State var reviewUser = false
    @State var nameEditor = ""
    @State var pfp = UIImage()
    
    @ObservedObject var imageLoader = ImageLoader()
    
    var isSelf: Bool
    
    var uid: String
    
    init(uid: String) {
        _userModel = StateObject(wrappedValue: UserViewModel(uid: uid))
        isSelf = false
        self.uid = uid
    }
    
    init() {
        _userModel = StateObject(wrappedValue: UserViewModel())
        isSelf = true
        self.uid = ""
    }
    
    var body: some View {
        ScrollView{
            HStack{
                if editing {
                    
                    Button(action: {
                        editPfp = true
                    }) {
                        Image(systemName: "photo.circle").resizable().padding()
                    }.frame(width: 130, height: 130).padding(.all, 20)
                    
                    TextField(text: $nameEditor){
                        Text("Nome")
                    }
                } else {
                    if userModel.pfpUrl != "" {
                        CircleImage(imageUrl: userModel.pfpUrl, diameter: 130, shadowRadius: 7).padding()
                    }
                    Text(userModel.name).font(.title)
                }
            }.frame(height: 150)
            HStack{
                VStack{
                    Text(String(userModel.nCars)).font(.title).bold()
                    Text("Auto")
                }.frame(minWidth: 0, maxWidth: .infinity)
                VStack{
                    Text(String(userModel.reviews.count)).font(.title).bold()
                    Text("Recensioni")
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
            
            if !isSelf {
                Button(action: {
                    reviewUser.toggle()
                }) {
                    Text("Recensisci")
                        .padding()
                        .frame(maxWidth: .infinity)
                }.background(Color.blue).foregroundColor(.white).clipShape(RoundedRectangle(cornerRadius: 10)).padding()
            }
            
            if (userModel.reviews.count > 0){
                ForEach(userModel.reviews) {rev in
                    ReviewCard(review: rev)
                }
            } else {
                VStack {
                    Spacer()
                    Text("Nessuna recensione").padding()
                    Spacer()
                }
            }
            
            
        }.toolbar {
            if isSelf {
                Button(action: {
                    if editing {
                        if nameEditor != userModel.name || pfp.size.width > 0 {
                            userModel.updateUserDetails(name: nameEditor, pfp: pfp.size.width > 0 ? pfp : nil)
                            pfp = UIImage()
                        }
                    } else {
                        nameEditor = userModel.name
                    }
                    editing.toggle()
                }){
                    if editing {
                        Image(systemName: "icloud.and.arrow.up.fill")
                    } else {
                        Image(systemName: "square.and.pencil")
                    }
                    
                }.foregroundColor(.primary)
            }
        }.sheet(isPresented: $editPfp) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$pfp)
        }
        .sheet(isPresented: $reviewUser) {
            ReviewSheet(userManager: userModel, uid: uid)
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
