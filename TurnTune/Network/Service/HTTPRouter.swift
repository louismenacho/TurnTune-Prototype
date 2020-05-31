//
//  HTTPRouter.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/31/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

class HTTPRouter<Endpoint: APIEndpoint> {
    
    func request(endpoint: Endpoint, completion: @escaping (Result<Codable,Error>) -> Void) {
        
    }
    
    private func buildRequest(from endpoint: Endpoint) throws -> URLRequest {
        guard let requestURL = endpoint.baseURL?.appendingPathComponent(endpoint.path) else {
            throw HTTPError.invalidURL
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = try {
            switch endpoint.contentType {
            case .none:
                request.url = try QueryParameterEncoder.encoded(request, with: endpoint.parameters!)
                return nil
            case .json:
                return try JSONParameterEncoder.encoded(request, with: endpoint.parameters!)
            case .xwwwformurlencoded:
                return URLParameterEncoder.encoded(request, with: endpoint.parameters!)
            }
        }()
        return request
    }
}
