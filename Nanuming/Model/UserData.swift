//
//  UserData.swift
//  Nanuming
//
//  Created by byeoungjik on 2/7/24.
//

import Foundation

struct UserData {
    let url: URL?
    let name: String
    let email: String
    
    init(url: URL?, name: String, email: String) {
        self.url = url
        self.name = name
        self.email = email
    }
}
