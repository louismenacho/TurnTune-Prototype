//
//  NetworkManager.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let clientID = "703fef1a418a49648d062f81bc35b559"
    let clientSecret = "e1a4d7ee7ff94855a5766c94948575f4"
    let redirectURI = "Spotify-Demo://spotify-login-callback"
    var spotifyAccessToken: Token?
    
    fileprivate let spotifyAccountServices = NetworkRouter<SpotifyAccountServices>()
    let spotifyWebAPI = NetworkRouter<SpotifyWebAPI>()
        
    // MARK: - Spotify Account Services
    
    func getAuthorizeRequest() -> URLRequest {
        guard let authorizeURL = SpotifyAccountServices.authorize.url, let authorizeParameters = SpotifyAccountServices.authorize.parameters else {
            fatalError("NetworkManager.getAuthorizeRequest")
        }
        var authorizeRequest = URLRequest(url: authorizeURL)
        ParameterEncoder.encode(request: &authorizeRequest, with: authorizeParameters)
        return authorizeRequest
    }
    
    
    func generateToken(authorization code: String, completion: @escaping (Result<Token, Error>) -> Void) {
        spotifyAccountServices.request(.token(authorizationCode: code)) { result in
            completion(result)
        }
    }
    
    // TODO: - Add refresh token function
    
    // MARK: - Spotify Web API
    
    func search(query: String, types: [String], completion: @escaping (Result<SearchResult, Error>) -> Void) {
        spotifyWebAPI.request(.search(query, types: types)) { completion($0) }
    }
    
    func search(track query: String, completion: @escaping (Result<[Track], Error>) -> Void) {
        spotifyWebAPI.request(.search(query, types: ["track"])) { (result: Result<SearchResult,Error>) in
            completion(result.map { $0.tracks.items })
        }
    }
    
    func search(artist query: String, completion: @escaping (Result<[Artist], Error>) -> Void) {
        spotifyWebAPI.request(.search(query, types: ["artist"])) { (result: Result<SearchResult,Error>) in
            completion(result.map { $0.artists.items })
        }
    }
    
    func search(album query: String, completion: @escaping (Result<[Album], Error>) -> Void) {
        spotifyWebAPI.request(.search(query, types: ["album"])) { (result: Result<SearchResult,Error>) in
            completion(result.map { $0.albums.items })
        }
    }
    
    func search(playlist query: String, completion: @escaping (Result<[Playlist], Error>) -> Void) {
        spotifyWebAPI.request(.search(query, types: ["playlist"])) { (result: Result<SearchResult,Error>) in
            completion(result.map { $0.playlists.items })
        }
    }
    
    // Playlists API
    
    func addTracks(tracks: [Track], completion: @escaping () -> Void) {}
    
    func removeTracks(tracks: [Track], completion: @escaping () -> Void) {}
    
    func createPlaylist(name: String, user: String, completion: @escaping (Result<Playlist, Error>) -> Void) {
        spotifyWebAPI.request(.createPlaylist(name: name, user: user)) { (result: Result<Playlist, Error>) in
            completion(result)
        }
    }
}
