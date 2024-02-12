//
//  BaseResponse.swift
//  Nanuming
//
//  Created by 가은 on 2/12/24.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    var success: Bool
    var status: Int
    var message: String
    var data: T?
}
