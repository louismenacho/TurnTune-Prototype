//
//  ViewController.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WKWebView()
        webView.frame = view.frame
        webView.navigationDelegate = self
        webView.load(NetworkManager.shared.getAuthorizeRequest())
        view.addSubview(webView)
    }
}

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let components = URLComponents(url: navigationAction.request.url!, resolvingAgainstBaseURL: true)!
        if components.host == "spotify-login-callback" {
            let authorizationCode = components.queryItems![0].value!
            
            let spotifyNetworkManager = NetworkManager.shared
            spotifyNetworkManager.generateToken(code: authorizationCode)
            spotifyNetworkManager.refreshToken()
            
//            let tracks = spotifyNetworkManager.search(track: "Feint")?.tracks.items
//            let playlist = spotifyNetworkManager.createPlaylist("TurnTune", for: "melo3450")
//            spotifyNetworkManager.addTracks(tracks!, to: playlist!)
//            spotifyNetworkManager.addTracks(tracks!, to: playlist!)
//            spotifyNetworkManager.addTracks(tracks!, to: playlist!)
//            spotifyNetworkManager.reorderTrack(from: 2, to: 0, in: playlist!)
//            spotifyNetworkManager.getTracks(for: playlist!)
//            spotifyNetworkManager.removeTracks(tracks!, from: playlist!)
//            spotifyNetworkManager.deletePlaylist(playlist!)
            
            webView.removeFromSuperview()
        }

        decisionHandler(.allow)
    }
}

