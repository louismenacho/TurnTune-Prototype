//
//  UserProfile.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/20/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct UserProfile: Codable {
    var id: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
    }
}
