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
    var spotifyApiToken: Token?
    
    fileprivate let group = DispatchGroup()
    
    fileprivate let spotifyAccountServicesRouter = NetworkRouter<SpotifyAccountServices>()
    fileprivate let spotifyWebApiRouter = NetworkRouter<SpotifyWebApi>()
    
    fileprivate func spotifyAccountServices<T: Codable>(request endpoint: SpotifyAccountServices) -> T? {
        var value: T?
        group.enter()
        spotifyAccountServicesRouter.request(endpoint) { (result: Result<T ,Error>) in
            value = self.handleResult(result)
            self.group.leave()
        }
        group.wait()
        return value
    }
    
    fileprivate func spotifyWebApi<T: Codable>(request endpoint: SpotifyWebApi) -> T? {
        var value: T?
        group.enter()
        spotifyWebApiRouter.request(endpoint) { (result: Result<T ,Error>) in
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
        
    // MARK: - Spotify Account Services
    
    func getAuthorizeRequest() -> URLRequest {
        guard let authorizeURL = SpotifyAccountServices.authorize.url, let authorizeParameters = SpotifyAccountServices.authorize.parameters else {
            fatalError("NetworkManager.getAuthorizeRequest")
        }
        var authorizeRequest = URLRequest(url: authorizeURL)
        ParameterEncoder.encode(request: &authorizeRequest, with: authorizeParameters)
        return authorizeRequest
    }
    
    
    func generateToken(authorization code: String) -> Token? {
        spotifyApiToken = spotifyAccountServices(request: .token(authorizationCode: code))
        return spotifyApiToken
    }
    
    // TODO: - Add refresh token function
    
    // MARK: - Spotify Web API
    
    // Search API
    
    func search(_ query: String, types: [String] = ["track","artist","album","playlist"]) -> SearchResult? {
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

    func search(playlist query: String) -> [Playlist]? {
        search(query, types: ["playlist"])?.playlists?.items
    }
    
    // Playlists API
    
    func getPlaylist(id: String) -> Playlist? {
        spotifyWebApi(request: .getPlaylist(playlistId: id))
    }
    
    @discardableResult
    func createPlaylist(for user: String, with name: String) -> Playlist? {
        spotifyWebApi(request: .createPlaylist(userId: user, name: name))
    }
    
    @discardableResult
    func deletePlaylist(id: String) -> String? {
        spotifyWebApi(request: .deletePlaylist(playlistId: id))
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
