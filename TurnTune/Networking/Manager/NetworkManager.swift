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
    
    let clientId = "695de2c68a184c69aaebdf6b2ed02260"
    let redirectUri = "TurnTune://spotify-login-callback"
    var spotifyApiToken: Token?
    
    fileprivate let group = DispatchGroup()
    
    fileprivate func spotifyTokenSwapApi<T: Codable>(request endpoint: SpotifyTokenSwapApi) -> T? {
        var value: T?
        group.enter()
        NetworkRouter<SpotifyTokenSwapApi>().request(endpoint) { (result: Result<T, Error>) in
            value = self.handleResult(result)
            self.group.leave()
        }
        group.wait()
        return value
    }
    
    fileprivate func spotifyWebApi<T: Codable>(request endpoint: SpotifyWebApi) -> T? {
        var value: T?
        group.enter()
        NetworkRouter<SpotifyWebApi>().request(endpoint) { (result: Result<T ,Error>) in
            value = self.handleResult(result)
            self.group.leave()
        }
        group.wait()
        return value
    }
    
    fileprivate func handleResult<T:Codable>(_ result: Result<T, Error>) -> T? {
        switch result {
        case .failure(let error):
            print("\(error): \(error.localizedDescription)")
            return nil
        case .success(let value):
            return value
        }
    }
        
    // MARK: - Spotify Accounts API
    
    func getAuthorizeRequest() -> URLRequest {
        let authorize: SpotifyAccountsApi = .authorize(clientId, redirectUri)
        var authorizeRequest = URLRequest(url: authorize.url!)
        ParameterEncoder.encode(request: &authorizeRequest, with: authorize.parameters!)
        return authorizeRequest
    }
    
    // MARK: - Spotify Token Swap API
    
    func generateToken(code: String) {
        spotifyApiToken = spotifyTokenSwapApi(request: .token(code))
    }
    
    func refreshToken() {
        spotifyApiToken = spotifyTokenSwapApi(request: .refreshToken(spotifyApiToken!.refresh!))
    }
    
    // MARK: - Spotify Web API
    
    // Search API
    
    func search(track query: String) -> SearchResult? {
        spotifyWebApi(request: .search(query, ["track"]))
    }
    
    // Playlists API
        
    @discardableResult
    func createPlaylist(_ name: String, for user: String) -> Playlist? {
        spotifyWebApi(request: .createPlaylist(user, name))
    }
    
    @discardableResult
    func deletePlaylist(_ playlist: Playlist) -> String? {
        spotifyWebApi(request: .deletePlaylist(playlist.id))
    }
    
    @discardableResult
    func getTracks(for playlist: Playlist) -> Paging<PlaylistTrack>? {
        spotifyWebApi(request: .getTracks(playlist.id))
    }
    
    @discardableResult
    func addTracks(_ tracks: [Track], to playlist: Playlist) -> Snapshot? {
        spotifyWebApi(request: .addTracks(playlist.id, tracks.map({$0.uri})))
    }
    
    @discardableResult
    func removeTracks(_ tracks: [Track], from playlist: Playlist) -> Snapshot? {
        spotifyWebApi(request: .removeTracks(playlist.id, tracks.map({$0.uri})))
    }
    
    @discardableResult
    func reorderTrack(from position: Int, to newPosition: Int, in playlist: Playlist) -> Snapshot? {
        spotifyWebApi(request: .reorderTrack(playlist.id, rangeStart: position, insertBefore: newPosition))
    }
}
