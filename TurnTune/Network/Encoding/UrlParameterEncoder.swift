//
//  URLParameterEncoder.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/30/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

public struct URLParameterEncoder {
    static func encode(_ request: inout URLRequest, with parameters: HTTPParameters) {
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        var components = URLComponents()
        components.queryItems = parameters.map({
            URLQueryItem(name: $0.key, value: "\($0.value)")
        })
        request.httpBody = components.query?.data(using: .utf8)
    }
}
