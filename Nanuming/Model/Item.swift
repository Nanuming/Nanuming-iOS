//
//  Item.swift
//  Nanuming
//
//  Created by byungjik on 2/13/24.
//

import Foundation

struct Item: Codable {
    var reservationId: Int?
    var memberId: Int?
    var itemId: Int?
    var lockerId: Int
}
