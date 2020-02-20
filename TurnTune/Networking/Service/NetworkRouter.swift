//
//  NetworkRouter.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

class NetworkRouter<Endpoint: EndpointType>: Router  {
    
    func request<T: Codable>(_ route: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        
        var request = URLRequest(url: route.url!)
        request.httpMethod = route.method.rawValue
        setHeaders(for: route, &request)
        setParameters(for: route, &request)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response else {
                completion(.failure(NetworkError.emptyResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.emptyData))
                return
            }
            
            switch self.handleNetworkResponse(response) {
            case .failure(let networkError):
                dump(response)
                completion(.failure(networkError))
                return
            case .success(let httpResponse):
                print(httpResponse.statusCode)
            }
            
            do {
                let value = try JSONDecoder().decode(T.self, from: data)
                completion(.success(value))
            } catch let error {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    fileprivate func setHeaders(for route: Endpoint, _ request: inout URLRequest) {
        guard let headers = route.headers else { return }
        HeaderEncoder.encode(request: &request, with: headers)
    }
    
    
    fileprivate func setParameters(for route: Endpoint, _ request: inout URLRequest) {
        guard let parameters = route.parameters else { return }
        ParameterEncoder.encode(request: &request, with: parameters, for: route.method)
    }
    
    fileprivate func handleNetworkResponse(_ response: URLResponse) -> Result<HTTPURLResponse, NetworkError> {
        let httpResponse = response as! HTTPURLResponse
        switch httpResponse.statusCode {
        case 200...299: return .success(httpResponse)
        case 400...499: return .failure(.clientError)
        case 500...599: return .failure(.serverError)
        default: return .failure(.networkError)
        }
    }
}
