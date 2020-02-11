//
//  NetworkResponse.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/11/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case failed
    case noData
    case authenticationError
    case badRequest
    case outdated
}
