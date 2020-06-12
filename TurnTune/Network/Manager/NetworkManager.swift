//
//  NetworkManager.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/4/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

class NetworkManager<Endpoint: APIEndpoint> {
   
    private var router = HTTPRouter<Endpoint>()
    
    func urlRequest(for endpoint: Endpoint) -> URLRequest? {
        return try? router.buildRequest(from: endpoint)
    }
    
    func request(_ endpoint: Endpoint, completion: @escaping ([String: Any]?) -> Void) {
        router.request(endpoint) { result in
            print("REQUEST: \(endpoint)")
            switch result {
            case.failure(let error):
                self.handleError(error)
            case.success(let response):
                self.handleHTTPResponse(response)
                completion(try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any])
            }
        }
    }
    
    private func handleHTTPResponse(_ response: HTTPResponse) {
        print("\(response.details.statusCode) \(HTTPURLResponse.localizedString(forStatusCode: response.details.statusCode))")
        print((try? JSONSerialization.jsonObject(with: response.data, options: [])) ?? "")
    }
     
    private func handleError(_ error: Error) {
        switch error {
        case is HTTPError:
            print((error as! HTTPError).localizedDescription)
        case is EncoderError:
            print((error as! EncoderError).localizedDescription)
        default:
            print(error.localizedDescription)
        }
    }
}
