//
//  JSONParameterEncoder.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/30/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

public struct JSONParameterEncoder {
    static func encode(_ request: inout URLRequest, with parameters: HTTPParameters) throws {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    }
    
    static func encoded(_ request: URLRequest, with parameters: HTTPParameters) throws -> Data {
        return try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    }
}
