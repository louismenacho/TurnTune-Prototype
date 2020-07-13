//
//  PlayRoomViewController.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/18/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import UIKit

class PlayRoomViewController: UIViewController {
    
    var viewModel: PlayRoomViewModel! {
        didSet {
            if !isViewLoaded { return }
            setup()
            tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil { return }
        setup()
    }
    
    func setup() {
        tableView.dataSource = self
        viewModel.membersChanged = { members in
            print(members)
        }
    }
}

extension PlayRoomViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        [
            "NOW PLAYING",
            "UP NEXT",
            "MEMBERS"
        ][section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        [
            1,
            1,
            viewModel.members.count
        ][section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.section == 3 ? "MemberTableViewCell" : "TrackTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        return cell
    }
}
