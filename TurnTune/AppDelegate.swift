//
//  AppDelegate.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: Spotify.ClientID, redirectURL: URL(string:Spotify.RedirectURL)!)
        configuration.tokenSwapURL = URL(string: Spotify.TokenSwapURL)
        configuration.tokenRefreshURL =  URL(string: Spotify.TokenRefreshURL)
        configuration.playURI = ""
        return configuration
    }()
    
    lazy var sessionManager: SPTSessionManager = {
        return SPTSessionManager(configuration: self.configuration, delegate: nil)
    }()
    
    lazy var appRemote: SPTAppRemote = {
        return SPTAppRemote(configuration: self.configuration, logLevel: .debug)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
