//
//  PlayerViewController.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/19/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    var playerViewModel: PlayerViewModel?
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension PlayerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionHeaderTitles = ["Now Playing", "Next in Queue", "From You"]
        return sectionHeaderTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell", for: indexPath) as! TrackTableViewCell
        cell.trackNameLabel.text = playerViewModel?.currentTrackName
        cell.artistNameLabel.text = playerViewModel?.currentTrackArtist
        return cell
    }
}

extension PlayerViewController: UITableViewDelegate {}
