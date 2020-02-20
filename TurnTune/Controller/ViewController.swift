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
            
            let token = NetworkManager.shared.generateToken(authorization: authorizationCode)
            dump(token)
            
            let playlist = NetworkManager.shared.createPlaylist(for: "melo3450", with: "TurnTune")
            dump(playlist)
            
            let tracks = NetworkManager.shared.search(track: "Feint")
            dump(tracks)
            
            let snapshot = NetworkManager.shared.addTracks(tracks: [tracks!.first!], to: playlist!)
            dump(snapshot)
            
            let getPlaylist = NetworkManager.shared.getPlaylist(id: playlist!.id)
            dump(getPlaylist)
            
            webView.removeFromSuperview()
        }

        decisionHandler(.allow)
    }
}

