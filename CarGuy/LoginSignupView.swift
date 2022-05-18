//
//  LoginView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 18/05/22.
//

import SwiftUI

struct LoginSignupView: View {
    @State var signup = false
    var body: some View {
        VStack {
            
            Image("AppLogo").resizable().scaledToFit().padding(.all, 40)
            
            //            ZStack{
            if signup {
                
                SignUpView().transition(.move(edge: .trailing).animation(.easeOut(duration: 0.4))).zIndex(1)
            } else {
                LoginView().transition(.move(edge: .leading).animation(.easeOut(duration: 0.4))).zIndex(0)
            }
            //            }
            Spacer()
            Button(action: {
                
                withAnimation() {
                    signup.toggle()
                }
            }) {
                if signup {
                    Text("Hai già un'account? Accedi")
                } else {
                    Text("Non hai un'account? Registrati")
                }
            }.padding()
        }.padding()
    }
}

class ModelData: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isSignedUp = false
    @Published var name_signup = ""
    @Published var email_signup = ""
    @Published var password_signup = ""
    @Published var resetEmail = ""
    @Published var isLinkSent = false
    @Published var isResetPresented = false
    
    func resetPassword() {
        let alert = UIAlertController(title:"Reset Password", message: "Inserisci la tua email", preferredStyle: .alert)
        alert.addTextField{ (password) in
            password.placeholder = "Email"
        }
        let reset = UIAlertAction(title: "Reset", style: .default) { (_) in
            self.resetEmail = alert.textFields![0].text!
            self.isLinkSent.toggle()
        }
        
        let cancel = UIAlertAction(title: "Annulla", style: .destructive, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(reset)
        
        //Deprecato, non ho trovato soluzioni conformi al pattern MVVM
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
}

struct LoginView: View {
    @StateObject var model = ModelData()
    
    var body: some View {
        VStack{
            Text("Accedi").font(.largeTitle).bold()
            VStack (alignment: .leading) {
                Text("E-Mail")
                TextField(text: $model.email){
                    Text("E-mail")
                }
                Divider()
            }.padding()
            VStack (alignment: .leading) {
                Text("Password")
                SecureField(text: $model.password){
                    Text("Password")
                }
                Divider()
            }.padding()
            
            HStack{
                Text("Accedi").font(.subheadline)
                Spacer()
                Image(systemName: "arrow.forward.circle.fill")
            }.frame(width: 100, height: 10)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Spacer()
            Button(action: model.resetPassword) {
                Text("Hai dimenticato la password?")
            }.padding()
        }.alert(isPresented: $model.isLinkSent){
            Alert(title: Text("Password Resettata"), message: Text("Il link per il reset della password è stato inviato alla tua e-mail"), dismissButton: .cancel(Text("Ok")))}
    }
}

struct SignUpView: View {
    @StateObject var model = ModelData()
    
    var body: some View {
        VStack{
            Text("Registrati").font(.largeTitle).bold()
            VStack (alignment: .leading) {
                Text("Nome")
                TextField(text: $model.name_signup){
                    Text("Nome")
                }
                Divider()
            }.padding()
            
            VStack (alignment: .leading) {
                Text("E-Mail")
                TextField(text: $model.email_signup){
                    Text("E-mail")
                }
                Divider()
            }.padding()
            
            VStack (alignment: .leading) {
                Text("Password")
                SecureField(text: $model.password_signup){
                    Text("Password")
                }
                Divider()
            }.padding()
            
            HStack{
                Text("Registrati").font(.subheadline)
                Spacer()
                Image(systemName: "arrow.forward.circle.fill")
            }.frame(width: 100, height: 10)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
        }
    }
}

struct LoginSignupView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignupView()
    }
}
