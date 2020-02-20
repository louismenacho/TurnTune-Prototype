//
//  SpotifyWebApi.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/12/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

enum SpotifyWebApi {
    case search(_ query: String, _ types: [String])
    case getPlaylist(playlistId: String)
    case addTracks(uris: [String], playlistId: String)
    case removeTracks(uris: [String], playlistId: String)
    case createPlaylist(userId: String, playlistName: String)
}

extension SpotifyWebApi: EndpointType {
    
    var host: String { "api.spotify.com" }
    
    var path: String {
        switch self {
        case .search:
            return "/v1/search"
        case .getPlaylist(let playlistId):
            return "/v1/playlists/\(playlistId)"
        case .createPlaylist(let userId, _):
            return "/v1/users/\(userId)/playlists"
        case .addTracks(_, let playlistId), .removeTracks(_, let playlistId):
            return "/v1/playlists/\(playlistId)/tracks"

        }
    }
    
    var method: HttpMethod {
        switch self {
        case .search, .getPlaylist:
            return .get
        case .createPlaylist, .addTracks, .removeTracks:
            return .post
        }
    }
    
    var headers: HttpHeaders? {
        guard let token = NetworkManager.shared.spotifyApiToken else { return nil }
        var httpHeader = ["Authorization": "Bearer \(token.access)"]
        
        switch self {
        case .createPlaylist, .addTracks, .removeTracks:
            httpHeader["Content-Type"] = "application/json"
        case .search, .getPlaylist:
            break
        }
        
        return httpHeader
    }
    
    var parameters: HttpParameters? {
        switch self {
        case .search(let query, let types):
            return ["q": query, "type": types.joined(separator: ",")]
        case .createPlaylist(_, let playlistName):
            return ["name": playlistName]
        case .addTracks(let uris, _), .removeTracks(let uris, _):
            return ["uris": uris]
        case .getPlaylist:
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
