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
    case createPlaylist(userId: String, name: String)
    case deletePlaylist(playlistId: String)
    case getTracks(playlistId: String)
    case addTracks(uris: [String], playlistId: String)
    case removeTracks(uris: [String], playlistId: String)
    case reorderTrack(rangeStart: Int, insertBefore: Int ,playlistId: String)
}

extension SpotifyWebApi: EndpointType {
    
    var host: String {
        "api.spotify.com"
    }
    
    var path: String {
        switch self {
        case .search:
            return "/v1/search"
        case let .createPlaylist(userId, _):
            return "/v1/users/\(userId)/playlists"
        case let .deletePlaylist(playlistId):
            return "/v1/playlists/\(playlistId)/followers"
        case let .getTracks(playlistId),
             let .addTracks(_, playlistId),
             let .removeTracks(_, playlistId),
             let .reorderTrack(_, _, playlistId):
            return "/v1/playlists/\(playlistId)/tracks"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .search, .getTracks:
            return .get
        case .createPlaylist, .addTracks, .removeTracks:
            return .post
        case .reorderTrack:
            return .put
        case .deletePlaylist:
            return .delete
        }
    }
        
    var headers: HttpHeaders? {
        guard let token = NetworkManager.shared.spotifyApiToken else { return nil }
        var httpHeader = ["Authorization": "Bearer \(token.access)"]
        
        switch self {
        case .createPlaylist, .addTracks, .removeTracks, .reorderTrack:
            httpHeader["Content-Type"] = contentType.rawValue
        case .search, .deletePlaylist, .getTracks:
            break
        }
        
        return httpHeader
    }
    
    var parameters: HttpParameters? {
        switch self {
        case let .search(query, types):
            return [
                "q": query,
                "type": types.joined(separator: ",")
            ]
        case let .createPlaylist(_, name):
            return [
                "name": name,
                "public": "false",
                "collaborative": "true"
            ]
        case let .addTracks(uris, _), let .removeTracks(uris, _):
            return [
                "uris": uris
            ]
        case let .reorderTrack(rangeStart, insertBefore, _):
            return [
                "range_start": rangeStart,
                "insert_before": insertBefore
            ]
        case .deletePlaylist, .getTracks:
            return nil
        }
    }
    
    var contentType: HttpContentType {
        switch self {
        case .createPlaylist, .addTracks, .removeTracks, .reorderTrack:
            return .json
        case .search, .deletePlaylist, .getTracks:
            return .none
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
