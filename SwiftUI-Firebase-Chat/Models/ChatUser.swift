//
//  ChatUser.swift
//  SwiftUI-Firebase-Chat
//
//  Created by Apekshik Panigrahi on 8/19/22.
//

import Foundation

struct ChatUser: Identifiable {
    var id = UUID()
    
    let uid, email, profileImageUrl: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }

}
