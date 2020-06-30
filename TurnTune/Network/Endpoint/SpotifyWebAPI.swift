//
//  SpotifyWebAPI.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/11/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

enum SpotifyWebAPI {
    // Users Profile API
    case currentUserProfile
    
    // Player API
    case addToQueue(_ uri: String)
    
    // Search API
    case search(_ query: String, _ types: [String])
    
    // Playlists API
    case createPlaylist(_ userId: String, _ name: String)
    case deletePlaylist(_ playlistId: String)
    
    // Tracks API
    case getTracks(_ playlistId: String)
    case addTracks(_ playlistId: String, _ uris: [String])
    case removeTracks(_ playlistId: String, _ uris: [String])
    case reorderTrack(_ playlistId: String, rangeStart: Int, insertBefore: Int)
}

extension SpotifyWebAPI: APIEndpoint {
    
    var baseURL: URL? {
        URL(string: "https://api.spotify.com/v1")
    }
    
    var path: String {
        switch self {
        // Users Profile API
        case .currentUserProfile:
            return "/me"
        
        // Player API
        case .addToQueue:
            return "/player/queue"
            
        // Search API
        case .search:
            return "/search"
            
        // Playlists API
        case let .createPlaylist(userId, _):
            return "/users/\(userId)/playlists"
        case let .deletePlaylist(playlistId):
            return "/playlists/\(playlistId)/followers"
            
        // Tracks API
        case let .getTracks(playlistId),
             let .addTracks(playlistId, _),
             let .removeTracks(playlistId, _),
             let .reorderTrack(playlistId, _, _):
            return "/playlists/\(playlistId)/tracks"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        // Users Profile API
        case .currentUserProfile:
            return .get
            
        // Playlists API
        case .addToQueue:
            return .post
            
        // Search API
        case .search:
            return .get
            
        // Playlists API
        case .createPlaylist:
            return .post
        case .deletePlaylist:
            return .delete
            
        // Tracks API
        case .getTracks:
            return .get
        case .addTracks,
             .removeTracks:
            return .post
        case .reorderTrack:
            return .put
        }
    }
    
    var headers: HTTPHeaders? {
        var headers = [HTTPHeaderField: HTTPHeaderValue]()
        headers[.contentType] = contentType
        return Dictionary(uniqueKeysWithValues: headers.map({($0.key.rawValue, $0.value.rawValue)}))
    }
    
    var parameters: HTTPParameters? {
        switch self {
        // Users Profile API
        case .currentUserProfile:
            return nil
            
        // Playlists API
        case let .addToQueue(uri):
            return ["uri": uri]
            
        // Search API
        case let .search(query, types):
            return [
                "q": query,
                "type": types.joined(separator: ",")
            ]
            
        // Playlists API
        case let .createPlaylist(_, name):
            return [
                "name": name,
                "public": "false",
                "collaborative": "true"
            ]
        case .deletePlaylist:
            return nil
            
        // Tracks API
        case .getTracks:
            return nil
        case let .addTracks(_, uris),
             let .removeTracks(_, uris):
            return [
                "uris": uris
            ]
        case let .reorderTrack(_, rangeStart, insertBefore):
            return [
                "range_start": rangeStart,
                "insert_before": insertBefore
            ]
        }
    }
    
    var contentType: HTTPHeaderValue? {
        switch self {
        // Users Profile API
        case .currentUserProfile:
            return .none
        
        // Playlists API
        case .addToQueue:
            return .json
            
        // Search API
        case .search:
            return .none
            
        // Playlists API
        case .createPlaylist:
            return .json
        case .deletePlaylist:
            return .none
            
        // Tracks API
        case .getTracks:
            return .none
        case .addTracks,
             .removeTracks,
             .reorderTrack:
            return .json
        }
    }
}
