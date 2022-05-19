//
//  MainView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 17/05/22.
//

import SwiftUI

enum Tabs:String {
    case garage
    case guys
    case explore
    case meets
}

struct MainView: View {
    @AppStorage("log_status") var isLogged = false
    @StateObject var loginModel = LoginModelData()
    
    @State var selectedTab: Tabs = .garage
    var body: some View {
        if !isLogged {
            LoginSignupView(model: loginModel)
        } else {
            TabView (selection: $selectedTab){
                NavigationView{
                    GarageView().navigationTitle("Garage")
                        .navigationBarItems(trailing:
                                                HStack {
                            Image(systemName: "bell").padding()
                            Image(systemName: "paperplane")
                        })
                }
                .tabItem {
                    Label("Garage", systemImage: "homekit")
                }.tag(Tabs.garage)
                NavigationView{
                    GuysView().navigationTitle("Guys")
                        .navigationBarItems(trailing:
                                                HStack {
                            Image(systemName: "bell").padding()
                            Image(systemName: "paperplane")
                        })
                }
                .tabItem {
                    Label("Guys", systemImage: "wrench.fill")
                }.tag(Tabs.guys)
                NavigationView{
                    MeetsView().navigationTitle("Meets")
                        .navigationBarItems(trailing:
                                                HStack {
                            Image(systemName: "bell").padding()
                            Image(systemName: "paperplane")
                        })
                }
                
                .tabItem {
                    Label("Meets", systemImage: "person.3.fill")
                }.tag(Tabs.meets)
                NavigationView{
                    ProfileView().navigationTitle("Profile")
                        .navigationBarItems(trailing:
                                                HStack {
                            Image(systemName: "bell").padding()
                            Image(systemName: "paperplane")
                        })
                }
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }.tag(Tabs.explore)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()//.environment(\.colorScheme, .dark)
    }
}
