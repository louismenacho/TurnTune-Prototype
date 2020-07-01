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
    
    var viewModel : RoomCreatorViewModel!
    
    @IBOutlet weak var roomCodeLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentWebView(load: viewModel.serviceAuthorizeRequest())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("here")
        if segue.identifier == "PlayRoomViewController" {
            let navigationController = segue.destination as! UINavigationController
            let playRoomViewController = navigationController.viewControllers[0] as! PlayRoomViewController
            viewModel.completion = {
                let playRoom = PlayRoom(from: self.viewModel)
                let playRoomViewModel = PlayRoomViewModel(with: playRoom)
                playRoomViewController.viewModel = playRoomViewModel
            }
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
        viewModel.createRoom()
    }
}

extension RoomCreatorViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let components = URLComponents(url: navigationAction.request.url!, resolvingAgainstBaseURL: true)
        if components?.host == "spotify-login-callback", let authorizationCode = components?.queryItems?[0].value {
            viewModel.generateToken(with: authorizationCode)
            viewModel.generateRoomCode()
            roomCodeLabel.text = viewModel.roomCode
            webView.removeFromSuperview()
        }
        decisionHandler(.allow)
    }
}
