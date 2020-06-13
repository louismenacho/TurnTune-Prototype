//
//  SpotifyAccountsService.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/30/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

enum SpotifyAccountsService {
    case authorize(_ clientID: String, _ redirectURI: String)
}

extension SpotifyAccountsService: APIEndpoint {
   
    var baseURL: URL? {
        URL(string: "https://accounts.spotify.com")
    }
    
    var path: String {
        switch self {
        case .authorize:
            return "/authorize"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .authorize:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        var headers = [HTTPHeaderField: HTTPHeaderValue]()
        headers[.contentType] = contentType
        return Dictionary(uniqueKeysWithValues: headers.map({($0.key.rawValue, $0.value.rawValue)}))
    }
    
    var parameters: HTTPParameters? {
        switch self {
        case let .authorize(cliendID, redirectURI):
            return [
                "client_id": cliendID,
                "redirect_uri": redirectURI,
                "response_type": "code",
                "scope": "playlist-modify-private"
            ]
        }
    }
    
    var contentType: HTTPHeaderValue? {
        switch self {
        case .authorize:
            return .none
        }
    }
}
