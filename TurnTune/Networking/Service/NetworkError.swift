//
//  NetworkError.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/11/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case nullResponse
    case nullData
    case clientError
    case serverError
    case networkError
}
