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
    @StateObject var loginModel = LoginViewModel()
    @State var logoutRequested = false
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
                            NavigationLink(destination: ChatsView().navigationTitle("Chats")){
                                Image(systemName: "paperplane")
                            }.foregroundColor(.primary)
                        })
                }
                .tabItem {
                    Label("Garage", systemImage: "homekit")
                }.tag(Tabs.garage)
                NavigationView{
                    GuysView().navigationTitle("Guys")
                }
                .tabItem {
                    Label("Guys", systemImage: "wrench.fill")
                }.tag(Tabs.guys)
                NavigationView{
                    MeetsView().navigationTitle("Meets")
                }
                .tabItem {
                    Label("Meets", systemImage: "person.3.fill")
                }.tag(Tabs.meets)
                NavigationView{
                    ProfileView().navigationTitle("Profile")
                        .navigationBarItems(trailing:
                                                Button(action: {
                            self.logoutRequested = true
                        }) {Image(systemName: "person.fill.xmark").foregroundColor(.primary)}).confirmationDialog("Effettuare il logout?", isPresented: $logoutRequested) {
                            Button("Logout", role: .destructive) {
                                loginModel.logOut()
                                self.logoutRequested = false
                                self.selectedTab = .garage
                            }
                            Button("Annulla", role: .cancel) {
                                self.logoutRequested = false
                            }
                        }
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
