//
//  SpotifyTokenSwap.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/11/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

enum SpotifyTokenSwap {
    case token(_ code: String)
    case refreshToken(_ refreshToken: String)

}

extension SpotifyTokenSwap: APIEndpoint {
    var baseURL: URL? {
        URL(string: "https://turntune-spotify-token-swap.herokuapp.com")
    }
    
    var path: String {
        switch self {
        case .token:
            return "/api/token"
        case .refreshToken:
            return "/api/refresh_token"
        }
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var headers: HTTPHeaders? {
        var headers = [HTTPHeaderField: HTTPHeaderValue]()
        headers[.contentType] = contentType
        return Dictionary(uniqueKeysWithValues: headers.map({($0.key.rawValue, $0.value.rawValue)}))
    }
    
    var parameters: HTTPParameters? {
        switch self {
        case .token(let code):
            return [
                "code": code
            ]
        case .refreshToken(let refreshToken):
            return [
                "refresh_token": refreshToken
            ]
        }
    }
    
    var contentType: HTTPHeaderValue? {
        .xwwwformurlencoded
    }
}
