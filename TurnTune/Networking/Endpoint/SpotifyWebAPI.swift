//
//  SpotifyWebAPI.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/12/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

enum SpotifyWebAPI {
    case search(_ query: String)
}

extension SpotifyWebAPI: EndpointType {
    
    var host: String { "api.spotify.com" }
    
    var path: String {
        switch self {
        case .search:
            return "/v1/search"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var headers: HttpHeaders? {
        guard let token = NetworkManager.shared.spotifyAccessToken else { return nil }
        return ["Authorization": "Bearer \(token.access)"]
    }
    
    var parameters: HttpParameters? {
        switch self {
        case .search(let query):
            return [
                "q": query,
                "type": "track"
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
