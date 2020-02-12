//
//  ParameterEncoder.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

class ParameterEncoder {
    
    static func encode(request: inout URLRequest, with parameters: HttpParameters, for httpMethod: HttpMethod = .get) {
        switch httpMethod {
        case .get:
            encodeQueryParameters(for: &request, with: parameters)
        case .post:
            encodeBodyParameters(for: &request, with: parameters)
        }
    }
    
    fileprivate static func encodeQueryParameters(for request: inout URLRequest, with parameters: HttpParameters) {
        guard let requestURL = request.url, var requestComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: false) else {
            fatalError("ParameterEncoder.encodeQueryParameters")
        }
        requestComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        request.url = requestComponents.url
    }
    
    
    fileprivate static func encodeBodyParameters(for request: inout URLRequest, with parameters: HttpParameters) {
        var bodyParameters = ""
        parameters.forEach { bodyParameters.append("&\($0.key)=\($0.value)") }
        bodyParameters.removeFirst()
        request.httpBody = bodyParameters.data(using: .utf8)
    }
    
}
