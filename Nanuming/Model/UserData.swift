//
//  UserData.swift
//  Nanuming
//
//  Created by byeoungjik on 2/7/24.
//

import Foundation

struct MemberData: Codable {
    var memberId: Int
    var providerId: String
    var nickname: String
    var token: TokenData?
}
struct TokenData: Codable {
    var accessToken: String?
    var refreshToken: String?
}
