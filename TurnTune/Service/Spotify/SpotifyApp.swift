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
    }
}

extension SpotifyApp: SPTSessionManagerDelegate {
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("SPTSession initiated")
        appRemote?.connectionParameters.accessToken = session.accessToken
        SpotifyApp.didInitiateSession?(.success(session))
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print(error.localizedDescription)
        SpotifyApp.didInitiateSession?(.failure(error))
    }
}

extension SPTSessionManager {
    func initiateSession(with scope: SPTScope, options: AuthorizationOptions = [], completion: @escaping ((Result<SPTSession, Error>) -> Void)) {
        initiateSession(with: scope, options: options)
        SpotifyApp.didInitiateSession = { completion($0) }
    }
}
