//
//  LoginViewModel.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 19/05/22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var name_signup = ""
    @Published var email_signup = ""
    @Published var password_signup = ""
    @Published var isLinkSent = false
    
    //Errori
    @Published var alert = false
    @Published var alertMsg = ""
    
    //Stato utente
    @AppStorage("log_status") var status = false
    
    //Caricamento
    @Published var isLoading = false
    
    /**
     Crea un alert con una textField per il recupero della password (automatizzato con firebase)
     */
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
    
    /**
     Esegue il login dell'utente tramite firebase
     */
    func loginUser() {
        withAnimation {
            isLoading = true
        }
        if email == "" || password == "" {
            self.alertMsg = "Inserisci tutti i campi."
            self.alert.toggle()
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            withAnimation {
                self.isLoading = false
            }
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
    
    /**
     Esegue la registrazione dell'utente, creando l'utente con FirebaseAuth, collegato ai suoi dati su Firestore e inviando la mail di verifica all'utente.
     */
    func signupUser() {
        withAnimation {
            isLoading = true
        }
        if email_signup == "" || password_signup == "" || name_signup == "" {
            self.alertMsg = "Inserisci tutti i campi."
            self.alert.toggle()
            return
        }
        Auth.auth().createUser(withEmail: email_signup, password: password_signup) { (result, error) in
            withAnimation {
                self.isLoading = false
            }
            if error != nil {
                self.alertMsg = error!.localizedDescription
                self.alert.toggle()
                return
            }
            let db = Firestore.firestore()
            db.collection("users").document(result!.user.uid).setData([
                "id": result!.user.uid,
                "name": self.name_signup,
                "email": self.email_signup,
                "password": self.password_signup,
                "profilePic": [],
                "cars": [],
                "chats": []
            ])
            result?.user.sendEmailVerification(completion: { (err) in
                
                if error != nil {
                    self.alertMsg = error!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.alertMsg = "Email di verifica inviata"
                self.alert.toggle()
                self.email_signup = ""
                self.password_signup = ""
                self.name_signup = ""
                
                return
                
            })
        }
    }
    
    /**
     Esegue il logout dell'utente dall'applicazione
     */
    func logOut() {
        withAnimation {
            isLoading = true
        }
        try! Auth.auth().signOut()
        withAnimation(.easeOut(duration: 0.2)){
            self.status = false
        }
        
        withAnimation {
            isLoading = false
        }
        self.email = ""
        self.password = ""
        self.email_signup = ""
        self.password_signup = ""
        self.name_signup = ""
    }
    
    
}
