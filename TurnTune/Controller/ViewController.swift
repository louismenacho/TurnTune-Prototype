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
            
            let snapshot = NetworkManager.shared.addTracks(tracks: Array(tracks!.prefix(5)), to: playlist!)
            dump(snapshot)
            
            dump(Array(tracks!.prefix(5)).map({ $0.name })) //print original list before reorder
            
            let snapshot2 = NetworkManager.shared.reorderTrack(from: 3, to: 0, in: playlist!)
            dump(snapshot2)
            
            let getPlaylist = NetworkManager.shared.getPlaylist(id: playlist!.id)
            dump(getPlaylist!.tracks.items.map({ $0.track.name })) //get updated playlist and print list again
            
            print(NetworkManager.shared.deletePlaylist(id: getPlaylist!.id)!)
            
            webView.removeFromSuperview()
        }

        decisionHandler(.allow)
    }
}

