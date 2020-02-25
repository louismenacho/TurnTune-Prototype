//
//  SpotifyAccountServices.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

enum SpotifyAccountServices {
    case authorize
    case token(authorizationCode: String)
}

extension SpotifyAccountServices: EndpointType {

    var host: String { "accounts.spotify.com" }
    
    var path: String {
        switch self {
        case .authorize:
            return "/authorize"
        case .token:
            return "/api/token"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .authorize:
            return .get
        case .token:
            return .post
        }
    }
    
    var headers: HttpHeaders? {
        switch self {
        case .authorize:
            return nil
        case .token:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }
    
    var parameters: HttpParameters? {
        switch self {
        case .authorize:
            return [
                "response_type": "code",
                "client_id": NetworkManager.shared.clientID,
                "redirect_uri": NetworkManager.shared.redirectURI,
                "scope": "playlist-modify-private"
            ]
        case .token(let authorizationCode):
            return [
                "grant_type": "authorization_code",
                "code": authorizationCode,
                "client_id": NetworkManager.shared.clientID,
                "client_secret": NetworkManager.shared.clientSecret,
                "redirect_uri": NetworkManager.shared.redirectURI
            ]
        }
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        return components.url
    }
}
