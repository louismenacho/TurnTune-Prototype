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
            NetworkManager.shared.generateToken(authorization: authorizationCode) { result in
                switch result {
                case .failure(let error):
                    print("failed to generate token")
                    print(error.localizedDescription)
                case .success(let token):
                    NetworkManager.shared.spotifyAccessToken = token
                }
            }
            webView.removeFromSuperview()
        }

        decisionHandler(.allow)
    }
}
