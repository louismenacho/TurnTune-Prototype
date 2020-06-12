//
//  URLParameterEncoder.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/30/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

public struct URLParameterEncoder {
    static func encode(_ request: inout URLRequest, with parameters: HTTPParameters) throws {
        guard let data: Data = {
            var components = URLComponents()
            components.queryItems = parameters.map({
                URLQueryItem(name: $0.key, value: "\($0.value)".addingPercentEncoding(withAllowedCharacters: .alphanumerics))
            })
            return components.query?.data(using: .utf8)
        }() else {
            throw EncoderError.invalidURLParameters
        }
        request.httpBody = data
    }
    
    static func encoded(_ request: URLRequest, with parameters: HTTPParameters) throws -> Data {
        guard let data: Data = {
            var components = URLComponents()
            components.queryItems = parameters.map({
                URLQueryItem(name: $0.key, value: "\($0.value)")
            })
            return components.query?.data(using: .utf8)
        }() else {
            throw EncoderError.invalidURLParameters
        }
        return data
    }
}
