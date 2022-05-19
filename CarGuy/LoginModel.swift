//
//  LoginModel.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 19/05/22.
//

import Foundation
import SwiftUI
import Firebase

class LoginModelData: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isSignedUp = false
    @Published var name_signup = ""
    @Published var email_signup = ""
    @Published var password_signup = ""
    @Published var isLinkSent = false
    @Published var isResetPresented = false
    
    //Errori
    @Published var alert = false
    @Published var alertMsg = ""
    
    //Stato utente
    @AppStorage("log_status") var status = false
    
    func resetPassword() {
        let alert = UIAlertController(title:"Reset Password", message: "Inserisci la tua email", preferredStyle: .alert)
        alert.addTextField{ (password) in
            password.placeholder = "Email"
        }
        let reset = UIAlertAction(title: "Reset", style: .default) { (_) in
            if alert.textFields![0].text! != "" {
                Auth.auth().sendPasswordReset(withEmail: alert.textFields![0].text!) { error in
                    if error != nil {
                        self.alertMsg = error!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    self.alertMsg = "Email di recupero password inviata con successo."
                    self.alert.toggle()
                    return
                }
                self.isLinkSent.toggle()
            }
            
        }
        
        let cancel = UIAlertAction(title: "Annulla", style: .destructive, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(reset)
        
        //Deprecato, non ho trovato soluzioni conformi al pattern MVVM
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
    func loginUser() {
        
        if email == "" || password == "" {
            self.alertMsg = "Inserisci tutti i campi."
            self.alert.toggle()
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.alertMsg = error!.localizedDescription
                self.alert.toggle()
                return
            }
            
            let user = Auth.auth().currentUser
            
            if !user!.isEmailVerified{
                self.alertMsg = "Verifica il tuo indirizzo Email"
                self.alert.toggle()
                try! Auth.auth().signOut()
                return
            }
            
            withAnimation{
                self.status = true
            }
        }
    }
    
    func signupUser() {
        if email_signup == "" || password_signup == "" || name_signup == "" {
            self.alertMsg = "Inserisci tutti i campi."
            self.alert.toggle()
            return
        }
        Auth.auth().createUser(withEmail: email_signup, password: password_signup) { (result, error) in
            if error != nil {
                self.alertMsg = error!.localizedDescription
                self.alert.toggle()
                return
            }
            
            result?.user.sendEmailVerification(completion: { (err) in
                
                if error != nil {
                    self.alertMsg = error!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.alertMsg = "Email di verifica inviata"
                self.alert.toggle()
                self.isSignedUp = false
                self.email_signup = ""
                self.password_signup = ""
                self.name_signup = ""
                
                return
                
            })
        }
    }
    
    func logOut() {
        try! Auth.auth().signOut()
        withAnimation{
            self.status = false
        }
        
        self.email = ""
        self.password = ""
        self.email_signup = ""
        self.password_signup = ""
        self.name_signup = ""
    }
    
    
}
