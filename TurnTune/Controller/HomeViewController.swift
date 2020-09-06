//
//  HomeViewController.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/1/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    lazy var sessionManager = (UIApplication.shared.delegate as! AppDelegate).sessionManager
    lazy var appRemote = (UIApplication.shared.delegate as! AppDelegate).appRemote
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func hostButtonPressed(_ sender: UIButton) {
        sessionManager.delegate = self
        if sessionManager.isSpotifyAppInstalled {
            sessionManager.initiateSession(with: .appRemoteControl, options: .default)
        } else {
            print("Spotify app not installed")
        }
    }
}

extension HomeViewController: SPTSessionManagerDelegate {
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("SPTSession initiated")
        DispatchQueue.main.async {
            self.appRemote.connectionParameters.accessToken = session.accessToken
            self.performSegue(withIdentifier: "HostViewController", sender: self)
        }
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print(error.localizedDescription)
    }
}
