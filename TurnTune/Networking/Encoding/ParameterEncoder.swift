//
//  ParameterEncoder.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

class ParameterEncoder {
    
    static func encode(request: inout URLRequest, with parameters: HttpParameters, in contentType: HttpContentType = .none) {
        switch contentType {
        case .none:
            encodeQueryParameters(for: &request, with: parameters)
        default:
            encodeBodyParameters(for: &request, with: parameters, in: contentType)
        }
    }
    
    fileprivate static func encodeQueryParameters(for request: inout URLRequest, with parameters: HttpParameters) {
        guard let requestURL = request.url, var requestComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: false) else {
            fatalError("ParameterEncoder.encodeQueryParameters")
        }
        requestComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        request.url = requestComponents.url
    }
    
    
    fileprivate static func encodeBodyParameters(for request: inout URLRequest, with parameters: HttpParameters, in contentType: HttpContentType) {
        switch contentType {
        case .json:
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        case .urlencoded:
            var bodyParameters = [String]()
            parameters.forEach { bodyParameters.append("\($0.key)=\($0.value)") }
            request.httpBody = bodyParameters.joined(separator: "&").data(using: .utf8)
        case .none:
            return
        }
    }
    
}
