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
    fileprivate let spotifyWebAPI = NetworkRouter<SpotifyWebAPI>()
    
    fileprivate func handleResult<T:Codable>(_ result: Result<T,Error>) -> T {
        switch result {
        case .failure(let error):
            print(result.self)
            fatalError(error.localizedDescription)
        case .success(let value):
            return value
        }
    }
    
    // MARK: - Spotify Account Services
    
    func getAuthorizeRequest() -> URLRequest {
        guard let authorizeURL = SpotifyAccountServices.authorize.url, let authorizeParameters = SpotifyAccountServices.authorize.parameters else {
            fatalError("NetworkManager.getAuthorizeRequest")
        }
        var authorizeRequest = URLRequest(url: authorizeURL)
        ParameterEncoder.encode(request: &authorizeRequest, with: authorizeParameters)
        return authorizeRequest
    }
    
    
    func getApiToken(authorization code: String, completion: @escaping (Token) -> Void) {
        spotifyAccountServices.request(.token(authorizationCode: code)) { (result: Result<Token, Error>) in
            completion(self.handleResult(result))
        }
    }
    
    // MARK: - Spotify Web API
    
    func search(track query: String, completion: @escaping ([Track]) -> Void) {
        spotifyWebAPI.request(.search(query)) { (result: Result<SearchResult, Error>) in
            completion(self.handleResult(result.map { $0.tracks.items }))
        }
    }
    
    func search(artist query: String, completion: @escaping ([Artist]) -> Void) {
        spotifyWebAPI.request(.search(query)) { (result: Result<SearchResult, Error>) in
            completion(self.handleResult(result.map { $0.artists.items }))
        }
    }
    
    func search(album query: String, completion: @escaping ([Album]) -> Void) {
        spotifyWebAPI.request(.search(query)) { (result: Result<SearchResult, Error>) in
            completion(self.handleResult(result.map { $0.albums.items }))
        }
    }
    
    func search(playlist query: String, completion: @escaping ([Playlist]) -> Void) {
        spotifyWebAPI.request(.search(query)) { (result: Result<SearchResult, Error>) in
            completion(self.handleResult(result.map { $0.playlists.items }))
        }
    }
}
