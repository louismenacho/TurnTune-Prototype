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
    
    let webView = WKWebView()
    let networkManager = NetworkManager<SpotifyAccountsService>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.frame = view.frame
        webView.navigationDelegate = self
        webView.load(networkManager.urlRequest(for: .authorize("client_id", "redirect_uri"))!)
    }
}

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        guard
            let components = URLComponents(url: navigationAction.request.url!, resolvingAgainstBaseURL: true),
            components.host == "spotify-login-callback",
            let authorizationCode = components.queryItems?[0].value
        else {
            return
        }
        print(authorizationCode)
        webView.removeFromSuperview()
    }
}
