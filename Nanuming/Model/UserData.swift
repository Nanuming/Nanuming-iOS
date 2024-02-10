//
//  UserData.swift
//  Nanuming
//
//  Created by byeoungjik on 2/7/24.
//

import Foundation
import GoogleSignIn

struct UserData {
    var email: String
    var nickname: String
    var IDToken: String
    var picture: URL?
    
    init(email: String, IDToken: String, picture: URL?) {
        self.email = email
        self.nickname = ""
        self.IDToken = IDToken
        self.picture = picture
        
    }
}
