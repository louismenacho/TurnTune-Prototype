//
//  EncodingError.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/30/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

enum EncodingError: String, Error {
    case missingURL = "missing URL from request"
    case invalidURL = "invalid URL in request"
}
