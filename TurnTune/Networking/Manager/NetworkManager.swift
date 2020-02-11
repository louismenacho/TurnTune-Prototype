//
//  File.swift
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
    let spotifyAccountServices = NetworkRouter<SpotifyAccountServices>()
    
    fileprivate func handleResult<T:Codable>(_ result: Result<T,Error>) -> T {
        switch result {
        case .failure(let error):
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
}
