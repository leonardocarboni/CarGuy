//
//  LoginView.swift
//  CarGuy
//
//  Created by Leonardo Carboni on 18/05/22.
//

import SwiftUI
import Firebase

struct LoginSignupView: View {
    @ObservedObject var model: LoginViewModel
    
    @State var signup = false
    
    var body: some View {
        
        ZStack {
            VStack {
                Image("AppLogo").resizable().scaledToFit().padding(.all, 40)
                
                if signup {
                    SignUpView(model: model).transition(.move(edge: .trailing).animation(.easeOut(duration: 0.4))).zIndex(1)
                } else {
                    LoginView(model: model).transition(.move(edge: .leading).animation(.easeOut(duration: 0.4))).zIndex(0)
                }
                
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
            
            if model.isLoading {
                LoadingView()
            }
        }
    }
}

struct LoginView: View {
    @ObservedObject var model: LoginViewModel
    
    var body: some View {
        VStack{
            Text("Accedi").font(.largeTitle).bold()
            
            VStack (alignment: .leading) {
                Text("E-Mail")
                TextField(text: $model.email){
                    Text("E-mail")
                }
                .keyboardType(.emailAddress).textContentType(.emailAddress)
                Divider()
            }.padding()
            
            VStack (alignment: .leading) {
                Text("Password")
                SecureField(text: $model.password){
                    Text("Password")
                }
                Divider()
            }.padding()
            
            Button(action: model.loginUser){
                HStack{
                    Text("Accedi").font(.subheadline)
                    Spacer()
                    Image(systemName: "arrow.forward.circle.fill")
                }.frame(width: 100, height: 10)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Spacer()
            
            Button(action: model.resetPassword) {
                Text("Hai dimenticato la password?")
            }.padding()
            
        }.alert(isPresented: $model.isLinkSent){
            Alert(title: Text("Password Resettata"), message: Text("Il link per il reset della password è stato inviato alla tua e-mail"), dismissButton: .cancel(Text("Ok")))}
        .alert(isPresented: $model.alert, content: {
            Alert(title: Text("Attenzione"), message: Text(model.alertMsg), dismissButton: .cancel(Text("Ok")))
        })
    }
}

struct SignUpView: View {
    @ObservedObject var model : LoginViewModel
    
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
                }.keyboardType(.emailAddress).textContentType(.emailAddress)
                Divider()
            }.padding()
            
            VStack (alignment: .leading) {
                Text("Password")
                SecureField(text: $model.password_signup){
                    Text("Password")
                }
                Divider()
            }.padding()
            
            Button(action: {
                model.signupUser()
            }){
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
            
        }.alert(isPresented: $model.alert, content: {
            Alert(title: Text("Message"), message: Text(model.alertMsg), dismissButton: .destructive(Text("Ok")))
        })
    }
}
