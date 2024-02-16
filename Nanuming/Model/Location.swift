//
//  Location.swift
//  Nanuming
//
//  Created by 가은 on 2/15/24.
//

import Foundation

struct Location {
    let latitude: Double
    let longitude: Double
}

// DTO
struct PlaceLocation: Codable {
    let locationId: Int
    let latitude: Double
    let longitude: Double
}

struct PostCellByLocation: Codable {
    let itemId: Int
    let mainItemImageUrl: String
    let title: String
    let locationName: String
    let categoryName: String
}

struct PostListByLocation: Codable {
    let locationInfoDtoList: [PlaceLocation]
    let itemOutlineDtoList: [PostCellByLocation]
}

struct PlacePostList: Codable {
    let itemOutlineDtoList: [PostCellByLocation]
}
