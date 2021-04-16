//
//  User.swift
//  line.bot
//
//  Created by 酒井駿斗 on 2021/04/13.
//

import Foundation
import Firebase
import FirebaseFirestore
class User{
    
    let email: String
    let username: String
    let createdAt: Timestamp
    let profileImageUrl: String
    
    init(dic: [String: Any] ) {
        self.email = dic["email"] as? String ?? ""
        self.username = dic["usrname"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.profileImageUrl = dic["profileImageUrl"] as? String ?? ""
    }
}
