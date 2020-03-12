//
//  SpotifyAccountsApi.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

enum SpotifyAccountsApi {
    case authorize(_ clientId: String, _ redirectUri: String)
}

extension SpotifyAccountsApi: EndpointType {

    var host: String {
        "accounts.spotify.com"
    }
    
    var path: String {
        switch self {
        case .authorize:
            return "/authorize"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .authorize:
            return .get
        }
    }
    
    var headers: HttpHeaders? {
        switch self {
        case .authorize:
            return nil
        }
    }
    
    var parameters: HttpParameters? {
        switch self {
        case let.authorize(clientId, redirectUri):
            return [
                "response_type": "code",
                "client_id": clientId,
                "redirect_uri": redirectUri,
                "scope": "playlist-modify-private"
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
