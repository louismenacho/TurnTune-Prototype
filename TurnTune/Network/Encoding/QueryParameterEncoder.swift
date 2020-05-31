//
//  QueryParameterEncoder.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/30/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

public struct QueryParameterEncoder {
    static func encode(_ request: inout URLRequest, with parameters: HTTPParameters) throws {
        guard let requestUrl = request.url else {
            throw EncodingError.missingUrl
        }
        guard var components = URLComponents(url: requestUrl, resolvingAgainstBaseURL: false) else {
            throw EncodingError.invalidUrl
        }
        components.queryItems = parameters.map({
            URLQueryItem(name: $0.key, value: "\($0.value)")
        })
        request.url = components.url
    }
}
