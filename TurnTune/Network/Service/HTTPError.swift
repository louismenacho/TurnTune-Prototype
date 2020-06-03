//
//  HTTPError.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/31/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

enum HTTPError: Error {
    case invalidURL
    case noResponse
    case noData
    case responseError
}

extension HTTPError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL in request"
        case .noResponse:
            return "No response"
        case .noData:
            return "No data"
        case .responseError:
            return "Response error"
        }
    }
}
