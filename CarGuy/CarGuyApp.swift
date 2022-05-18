//
//  CarGuyApp.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 17/05/22.
//

import SwiftUI
//Firebase Setup
import Firebase

final class AppDeleagate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct CarGuyApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
