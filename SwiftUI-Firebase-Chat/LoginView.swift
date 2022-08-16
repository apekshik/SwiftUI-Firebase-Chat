//
//  LoginView.swift
//  SwiftUI-Firebase-Chat
//
//  Created by Apekshik Panigrahi on 8/15/22.
//

import SwiftUI
import Firebase


struct LoginView: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
     
    
    var body: some View {
        NavigationView {
            ScrollView {
                 VStack(spacing: 16) {
                     Picker(selection: $isLoginMode, label: Text("Picker here")) {
                         Text("Login")
                             .tag(true)
                         Text("Create Account")
                             .tag(false)
                     }.pickerStyle(SegmentedPickerStyle())
                         
                     if !isLoginMode {
                         Button {
                             
                         } label: {
                             Image(systemName: "person.fill")
                                 .font(.system(size: 64))
                                 .padding()
                         }
                     }
                     
                     VStack {
                         Divider()
                         TextField("Email", text: $email)
                             .keyboardType(.emailAddress)
                             .autocapitalization(.none)
                         Divider()
                         SecureField("Password", text: $password)
                         Divider()
                     }
                     .padding(12)
                     
                     Button {
                         handleAction()
                     } label: {
                         HStack {
                             Spacer()
                             Text(isLoginMode ? "Log In" : "Create Account")
                                 .foregroundColor(.white)
                                 .padding(.vertical, 10)
                                 .font(.system(size: 14, weight: .semibold))
                                 .cornerRadius(20)
                             Spacer()
                         }.background(Color.blue)
                         
                     }
                     Text(self.loginStatusMessage)
                 }
                 .padding()
                 
             }
             .navigationTitle(isLoginMode ? "Log In" : "Create Account")
             .background(Color(.init(white: 0, alpha: 0.05))
                             .ignoresSafeArea())
         }
         .navigationViewStyle(StackNavigationViewStyle())
     }
     
    private func handleAction() {
        if isLoginMode {
            loginUser()
            //print("Should log into Firebase with existing credentials")
        } else {
            createNewAccount()
            //print("Register a new account inside of Firebase Auth and then store image in Storage somehow....")
        }
    }
    
        
    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to Log in user: ", err)
                self.loginStatusMessage = "Failed to Log in user \(err)"
                return // bail out return
            }
            
            print("Successfully Logged in user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully Logged in user: \(result?.user.uid ?? "")"
        }
    }
    @State var loginStatusMessage = ""
    
    private func createNewAccount() {
        Auth.auth().createUser(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Faile to create new user: ", err)
                self.loginStatusMessage = "Failed to create new user \(err)"
                return // bail out return
            }
            
            print("Successfully created new user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully created new user: \(result?.user.uid ?? "")"
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
