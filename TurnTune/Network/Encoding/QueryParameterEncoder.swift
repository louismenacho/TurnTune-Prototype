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
            throw EncodingError.missingURL
        }
        guard var components = URLComponents(url: requestUrl, resolvingAgainstBaseURL: false) else {
            throw EncodingError.invalidURL
        }
        components.queryItems = parameters.map({
            URLQueryItem(name: $0.key, value: "\($0.value)")
        })
        request.url = components.url
    }
    
    static func encoded(_ request: URLRequest, with parameters: HTTPParameters) throws -> URL? {
        guard let requestUrl = request.url else {
            throw EncodingError.missingURL
        }
        guard var components = URLComponents(url: requestUrl, resolvingAgainstBaseURL: false) else {
            throw EncodingError.invalidURL
        }
        components.queryItems = parameters.map({
            URLQueryItem(name: $0.key, value: "\($0.value)")
        })
        return components.url
    }
}
