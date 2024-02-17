//
//  Post.swift
//  Nanuming
//
//  Created by 가은 on 2/2/24.
//

import SwiftUI

struct Post {
    var publisher: String? = "유가은"               // 게시물 올린 사람의 닉네임
    var createdDate: String? = "2024.01.31"      // 생성일자
    var title: String? = "루피 인형 나눔합니다"
    var image: [String?] = [""]
    var category: String? = "장난감"
    var location: String? = "자양4동 어린이집"
    var contents: String? = "나눔합니다"
    var likeNum: Int? = 0
    var isMyPost: Bool? = false                  // 본인 게시물인지
}

struct PostId: Codable {
    var id: Int
}

struct PostDetail: Codable {
    var itemId: String?
    var itemImageUrlList: [String?]
    var category: String?
    var locationName: String?
    var nickname: String?
    var title: String?
    var description: String?
    var createAt: String?
    var updateAt: String?
    var owner: Bool?
}
struct ImageAuth: Codable {
    var confirmItemImageId: Int
}
