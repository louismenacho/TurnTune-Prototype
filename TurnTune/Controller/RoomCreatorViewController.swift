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
        roomCreatorViewModel.service = .spotify
        presentWebView(load: roomCreatorViewModel.serviceAuthorizeRequest())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayRoomViewController" {
            let playRoom = PlayRoom(with: roomCreatorViewModel.roomCode, token: roomCreatorViewModel.token)
            let playRoomViewModel = PlayRoomViewModel(with: playRoom)
            let navigationController = segue.destination as! UINavigationController
            let playRoomViewController = navigationController.viewControllers[0] as! PlayRoomViewController
            playRoomViewController.playRoomViewModel = playRoomViewModel
        }
    }
    
    func presentWebView(load request: URLRequest) {
        let webView = WKWebView()
        webView.frame = view.frame
        webView.navigationDelegate = self
        webView.load(request)
        view.addSubview(webView)
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "PlayRoomViewController", sender: self)
    }
}

extension RoomCreatorViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let components = URLComponents(url: navigationAction.request.url!, resolvingAgainstBaseURL: true)
        if components?.host == "spotify-login-callback", let authorizationCode = components?.queryItems?[0].value {
            roomCreatorViewModel.generateToken(with: authorizationCode)
            roomCreatorViewModel.generateRoomCode()
            roomCodeLabel.text = roomCreatorViewModel.roomCode
            webView.removeFromSuperview()
        }
        decisionHandler(.allow)
    }
}
