//
//  SpotifyTokenSwapApi.swift
//  TurnTune
//
//  Created by Louis Menacho on 3/8/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

enum SpotifyTokenSwapApi {
    case token(_ code: String)
    case refreshToken(_ refreshToken: String)
}

extension SpotifyTokenSwapApi: EndpointType {
    
    var host: String {
        "turntune-spotify-token-swap.herokuapp.com"
    }
    
    var path: String {
        switch self {
        case .token:
            return "/api/token"
        case .refreshToken:
            return "/api/refresh_token"
        }
    }
    
    var method: HttpMethod {
        .post
    }
    
    var headers: HttpHeaders? {
        nil
    }
    
    var parameters: HttpParameters? {
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
    
    var contentType: HttpContentType {
        .none
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        return components.url
    }
}
