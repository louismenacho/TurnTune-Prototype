//
//  ParameterEncoder.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

class ParameterEncoder {
    
    enum ContentType: String {
        case xwwwformurlencoded = "application/x-www-form-urlencoded"
        case json = "application/json"
    }
    
    static func encode(request: inout URLRequest, with parameters: HttpParameters, for httpMethod: HttpMethod = .get) {
        switch httpMethod {
        case .get:
            encodeQueryParameters(for: &request, with: parameters)
        case .post, .put:
            encodeBodyParameters(for: &request, with: parameters)
        case .delete:
            break
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
        guard let contentType = request.value(forHTTPHeaderField: "Content-Type") else { return }
        switch ContentType(rawValue: contentType) {
        case .xwwwformurlencoded:
            var bodyParameters = [String]()
            parameters.forEach { bodyParameters.append("\($0.key)=\($0.value)") }
            request.httpBody = bodyParameters.joined(separator: "&").data(using: .utf8)
        case .json:
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        case .none:
            return
        }
    }
    
}
