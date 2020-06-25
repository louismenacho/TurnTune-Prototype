//
//  Paging.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/20/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct Paging<T: Codable>: Codable {
    var href: String
    var items: [T]
    var limit: Int
    var next: String?
    var offset: Int
    var previous: String?
    var total: Int

    enum CodingKeys: String, CodingKey {
        case href = "href"
        case items = "items"
        case limit = "limit"
        case next = "next"
        case offset = "offset"
        case previous = "previous"
        case total = "total"
    }
}
