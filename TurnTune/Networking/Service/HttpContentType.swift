//
//  HttpContentType.swift
//  TurnTune
//
//  Created by Louis Menacho on 3/8/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

enum HttpContentType: String {
    case none
    case json = "application/json"
    case urlencoded = "application/x-www-form-urlencoded"
}
