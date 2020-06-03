//
//  HTTPRouter.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/31/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

class HTTPRouter<Endpoint: APIEndpoint> {
    
    func request(endpoint: Endpoint, completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            let request = try buildRequest(from: endpoint)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(HTTPError.noData))
                    return
                }
                
                guard let response = response else {
                    completion(.failure(HTTPError.noResponse))
                    return
                }
                
                guard 200...299 ~= (response as! HTTPURLResponse).statusCode  else {
                    completion(.failure(HTTPError.responseError))
                    return
                }
                
                completion(.success(data))
            }
            .resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    func buildRequest(from endpoint: Endpoint) throws -> URLRequest {
        guard let requestURL = endpoint.baseURL?.appendingPathComponent(endpoint.path) else {
            throw HTTPError.invalidURL
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        if let parameters = endpoint.parameters {
            switch endpoint.contentType {
            case .json:
                try JSONParameterEncoder.encode(&request, with: parameters)
            case .xwwwformurlencoded:
                try URLParameterEncoder.encode(&request, with: parameters)
            case .none:
                try QueryParameterEncoder.encode(&request, with: parameters)
            }
        }
        return request
    }
}
