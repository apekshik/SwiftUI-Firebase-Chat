//
//  SwiftUI_Firebase_ChatApp.swift
//  SwiftUI-Firebase-Chat
//
//  Created by Apekshik Panigrahi on 8/15/22.
//

import SwiftUI
import Firebase 
@main
struct SwiftUI_Firebase_ChatApp: App {
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
