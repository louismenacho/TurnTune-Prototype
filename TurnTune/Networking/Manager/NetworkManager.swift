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
        spotifyApiToken = spotifyTokenSwapApi(request: .refreshToken(spotifyApiToken!.refresh))
    }
    
    // MARK: - Spotify Web API
    
    // Search API
    
    func search(_ query: String, types: [String] = ["track","artist","album"]) -> SearchResult? {
        spotifyWebApi(request: .search(query, types))
    }
    
    func search(track query: String) -> [Track]? {
        search(query, types: ["track"])?.tracks?.items
    }

    func search(artist query: String) -> [Artist]? {
        search(query, types: ["artist"])?.artists?.items
    }

    func search(album query: String) -> [Album]? {
        search(query, types: ["album"])?.albums?.items
    }
    
    // Playlists API
        
    @discardableResult
    func createPlaylist(for user: String, with name: String) -> Playlist? {
        spotifyWebApi(request: .createPlaylist(userId: user, name: name))
    }
    
    @discardableResult
    func deletePlaylist(id: String) -> String? {
        spotifyWebApi(request: .deletePlaylist(playlistId: id))
    }
    
    @discardableResult
    func getTracks(for playlist: Playlist) -> PlaylistTrackResult? {
        spotifyWebApi(request: .getTracks(playlistId: playlist.id))
    }
    
    @discardableResult
    func addTracks(tracks: [Track], to playlist: Playlist) -> Snapshot? {
        spotifyWebApi(request: .addTracks(uris: tracks.map({$0.uri}), playlistId: playlist.id))
    }
    
    @discardableResult
    func removeTracks(tracks: [Track], from playlist: Playlist) -> Snapshot? {
        spotifyWebApi(request: .removeTracks(uris: tracks.map({$0.uri}), playlistId: playlist.id))
    }
    
    @discardableResult
    func reorderTrack(from position: Int, to newPosition: Int, in playlist: Playlist) -> Snapshot? {
        spotifyWebApi(request: .reorderTrack(rangeStart: position, insertBefore: newPosition, playlistId: playlist.id))
    }
}
