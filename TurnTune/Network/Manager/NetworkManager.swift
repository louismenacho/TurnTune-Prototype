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
    
    func request(_ endpoint: Endpoint, completion: @escaping (Data) -> Void) {
        router.request(endpoint) { result in
            switch result {
            case.failure(let error):
                self.handleError(error)
            case.success(let (data, response)):
                self.handleData(data)
                self.handleResponse(response)
                completion(data)
            }
        }
    }
    
    func handleData(_ data: Data) {
        print((try? JSONSerialization.jsonObject(with: data, options: [])) ?? "")
    }
    
    func handleResponse( _ response: HTTPURLResponse) {
        print("\(response.statusCode) \(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))")
    }
    
    func handleError(_ error: Error) {
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
