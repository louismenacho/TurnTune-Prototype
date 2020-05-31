//
//  EncodingError.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/30/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

enum EncodingError: String, Error {
    case missingUrl = "missing URL from request"
    case invalidUrl = "invalid URL in request"
}
