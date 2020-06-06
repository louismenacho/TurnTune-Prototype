//
//  EncoderError.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/3/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

public enum EncoderError: Error {
    case invalidJSONParameters(description: String)
    case invalidURLParameters
    case invalidQueryParameters
}

extension EncoderError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .invalidJSONParameters(let description):
            return description
        case .invalidURLParameters:
            return "Failed to encode URL parameters"
        case .invalidQueryParameters:
            return "Failed to encode query parameters"
        }
    }
}
