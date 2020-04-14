//
//  Followers.swift
//  TurnTune
//
//  Created by Louis Menacho on 3/19/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct Followers: Codable {
    var href: String?
    var total: Int

    enum CodingKeys: String, CodingKey {
        case href = "href"
        case total = "total"
    }
}
