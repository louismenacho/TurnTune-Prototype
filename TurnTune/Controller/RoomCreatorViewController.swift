//
//  RoomCreatorViewController.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import UIKit
import WebKit

class RoomCreatorViewController: UIViewController {
    
    var roomCreatorViewModel : RoomCreatorViewModel!
    
    @IBOutlet weak var roomCodeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = WKWebView()
        webView.frame = view.frame
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.load(roomCreatorViewModel.serviceAuthorization())
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "PlayRoomViewController", sender: self)
    }
}

extension RoomCreatorViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        guard
            let components = URLComponents(url: navigationAction.request.url!, resolvingAgainstBaseURL: true),
            components.host == "spotify-login-callback",
            let authorizationCode = components.queryItems?[0].value
        else {
            return
        }
        roomCodeLabel.text = roomCreatorViewModel.roomCode
        print(authorizationCode)
        webView.removeFromSuperview()
    }
}
