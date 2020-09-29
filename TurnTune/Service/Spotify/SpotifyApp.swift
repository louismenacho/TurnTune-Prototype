//
//  SpotifyApp.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/27/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

class SpotifyApp: NSObject {
    
    static let app: SpotifyApp = SpotifyApp()
    static var configuration: SPTConfiguration { app.configuration! }
    static var sessionManager: SPTSessionManager { app.sessionManager! }
    static var appRemote: SPTAppRemote { app.appRemote! }
    
    static var didInitiateSession: ((Result<SPTSession, Error>) -> Void)?
    static var didConnectAppRemote: ((Result<SPTAppRemote, Error>) -> Void)?
    static var playerStateDidChange: ((SPTAppRemotePlayerState) -> Void)?

    private var configuration: SPTConfiguration?
    private var sessionManager: SPTSessionManager?
    private var appRemote: SPTAppRemote?
        
    static func configure() {
        guard
            let path = Bundle.main.path(forResource: "SpotifyService-Info", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let credentials = try? PropertyListDecoder().decode(SPTCredentials.self, from: xml)
        else {
            print("Could not configure SpotifyApp")
            return
        }
        
        let configuration = SPTConfiguration(clientID: credentials.ClientID, redirectURL: URL(string:credentials.RedirectURL)!)
        configuration.tokenSwapURL = URL(string: credentials.TokenSwapURL)
        configuration.tokenRefreshURL =  URL(string: credentials.TokenRefreshURL)
        configuration.playURI = ""
        
        app.configuration = configuration
        app.sessionManager = SPTSessionManager(configuration: configuration, delegate: app)
        app.appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        app.appRemote?.delegate = app
    }
}


extension SpotifyApp: SPTSessionManagerDelegate {
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("SPTSession initiated")
        SpotifyApp.didInitiateSession?(.success(session))
        appRemote?.connectionParameters.accessToken = session.accessToken
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print(error.localizedDescription)
        SpotifyApp.didInitiateSession?(.failure(error))
    }
}


extension SpotifyApp: SPTAppRemoteDelegate {

    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("SPTAppRemote connection established")
        SpotifyApp.didConnectAppRemote?(.success(appRemote))
        if let playerAPI = appRemote.playerAPI {
            playerAPI.delegate = SpotifyApp.app
            playerAPI.subscribe(toPlayerState: { print($1?.localizedDescription ?? "subscribed to playerState") })
        }
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            SpotifyApp.didConnectAppRemote?(.failure(error))
        }
    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
}


extension SpotifyApp: SPTAppRemotePlayerStateDelegate {
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        SpotifyApp.playerStateDidChange?(playerState)
    }
}
