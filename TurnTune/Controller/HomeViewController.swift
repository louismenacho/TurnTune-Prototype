//
//  HomeViewController.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/1/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func hostButtonPressed(_ sender: UIButton) {
        viewModel.host(name: "Louis") { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success:
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "HostViewController", sender: self)
                }
            }
        }
    }
}
