//
//  Location.swift
//  Nanuming
//
//  Created by 가은 on 2/15/24.
//

import Foundation

// DTO
struct PostListByLocation: Codable {
    let locationId: Int
    let latitude: Double
    let longitude: Double
    let itemOutlineDtoList: PostCell
}

struct PostCell: Codable {
    let itemId: Int
    let mainItemImageUrl: String
    let title: String
    let locationName: String
    let categoryName: String
}
