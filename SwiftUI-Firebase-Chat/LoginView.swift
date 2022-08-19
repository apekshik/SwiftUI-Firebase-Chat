//
//  LoginView.swift
//  SwiftUI-Firebase-Chat
//
//  Created by Apekshik Panigrahi on 8/15/22.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    
    let didCompleteLoginProcess: () -> ()
    
    @State private var isLoginMode = false
    @State private var email = ""
    @State private var password = ""
     
    @State private var shouldShowImagePicker = false
    @State private var image: UIImage?
    
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
                                 shouldShowImagePicker.toggle()
                             } label: {
                                 VStack {
                                     if let image = self.image {
                                         Image(uiImage: image)
                                             .resizable()
                                             .scaledToFill()
                                             .frame(width: 128, height: 128)
                                             .cornerRadius(20)
                                     } else {
                                         Image(systemName: "person.fill")
                                             .font(.system(size: 64))
                                             .padding()
                                             .foregroundColor(Color(.label))
                                             .overlay(RoundedRectangle(cornerRadius: 64)
                                                         .stroke(Color.black, lineWidth: 3)
                                             )
                                     }
                                 }
                                 
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
                                .frame(height: 50)
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
         .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
              ImagePicker(image: $image)
                  .ignoresSafeArea()
          }
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
            
            self.didCompleteLoginProcess()
        }
    }
    @State var loginStatusMessage = ""
    
    private func createNewAccount() {
        if self.image == nil {
            self.loginStatusMessage = "Must select image to create new account."
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Faile to create new user: ", err)
                self.loginStatusMessage = "Failed to create new user \(err)"
                return // bail out return
            }
            
            print("Successfully created new user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully created new user: \(result?.user.uid ?? "")"
            
            self.persistImageToStorage()
        }
    }
    
    private func persistImageToStorage() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Storage.storage().reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                self.loginStatusMessage = "Failed to push image to Storage: \(err)"
                return
            }

            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }

                self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                print(url?.absoluteString ?? "")
                
                guard let url = url else { return }
                self.storeUserInformation(imageProfileUrl: url)
            }
        }
    }
    
    private func storeUserInformation(imageProfileUrl: URL) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userData = ["email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        Firestore.firestore().collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    self.loginStatusMessage = "\(err)"
                    return
                }

                print("Success")
                
                self.didCompleteLoginProcess()
            }
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(didCompleteLoginProcess: {
            
        })
    }
}
