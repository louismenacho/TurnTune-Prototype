//
//  Token.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct Token: Codable {
    let access: String
    let type: String
    let scope: String
    let expiresIn: Int
    let refresh: String

    enum CodingKeys: String, CodingKey {
        case access = "access_token"
        case type = "token_type"
        case scope
        case expiresIn = "expires_in"
        case refresh = "refresh_token"
    }
}
