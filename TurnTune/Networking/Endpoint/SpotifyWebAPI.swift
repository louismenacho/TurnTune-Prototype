//
//  SpotifyWebAPI.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/12/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

enum SpotifyWebAPI {
    case search(_ query: String, types: [String])
    case addTracks(uris: [String], playlist: String)
    case removeTracks(uris: [String], playlist: String)
    case createPlaylist(name: String, user: String)
}

extension SpotifyWebAPI: EndpointType {
    
    var host: String { "api.spotify.com" }
    
    var path: String {
        switch self {
        case .search:
            return "/v1/search"
        case .addTracks(let uris, let playlist),
             .removeTracks(let uris, let playlist):
            return "/v1/playlists/\(playlist)/\(uris.joined(separator: ","))"
        case .createPlaylist(_, let user):
            return "/v1/users/\(user)/playlists"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .search:
            return .get
        case .addTracks,
             .removeTracks,
             .createPlaylist:
            return .post
        }
    }
    
    var headers: HttpHeaders? {
        guard let token = NetworkManager.shared.spotifyAccessToken else { return nil }
        var httpHeader = ["Authorization": "Bearer \(token.access)"]
        
        switch self {
        case .createPlaylist:
            httpHeader["Content-Type"] = "application/json"
        case .search,
             .addTracks,
             .removeTracks:
            break
        }
        
        return httpHeader
    }
    
    var parameters: HttpParameters? {
        switch self {
        case .search(let query, let types):
            return [
                "q": query,
                "type": types.joined(separator: ",")
            ]
        case .createPlaylist(let name, _):
            return ["name": name]
        case .addTracks, .removeTracks:
            return nil
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
