//
//  SPTCredentials.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/27/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct SPTCredentials: Codable {
    var ClientID: String
    var RedirectURL: String
    var TokenSwapURL: String
    var TokenRefreshURL: String
}
