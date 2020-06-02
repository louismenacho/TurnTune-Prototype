//
//  HTTPError.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/31/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

enum HTTPError: String, Error {
    case missingURL = "Missing URL in request"
    case invalidURL = "Invalid URL in request"
    case noResponse = "No response"
    case noData = "No data"
    case responseError = "Response error"
}
