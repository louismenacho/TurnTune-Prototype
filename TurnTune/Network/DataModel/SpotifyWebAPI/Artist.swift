//
//  Artist.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/20/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct Artist: Codable {
    var name: String

    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}
