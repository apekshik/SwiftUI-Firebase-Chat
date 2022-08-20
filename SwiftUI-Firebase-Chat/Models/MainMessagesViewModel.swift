//
//  MainMessagesViewModel.swift
//  SwiftUI-Firebase-Chat
//
//  Created by Apekshik Panigrahi on 8/20/22.
//

import Foundation

class MainMessagesViewModel: ObservableObject {

    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?

    init() {
        fetchCurrentUser()
        DispatchQueue.main.async {
                 self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
             }
    }

    func fetchCurrentUser() {

        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }

        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }

            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return

            }
            
            self.chatUser = .init(data: data)
        }
    }
    
    @Published var isUserCurrentlyLoggedOut = false
    
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }

}
