//
//  RoomViewController.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController  {
    
    var roomViewModel: RoomViewModel!
    var searcherViewModel: SearcherViewModel!
    var playerViewModel: PlayerViewModel?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = roomViewModel.roomCode
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        roomViewModel.roomStateDidChange = {
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
        
        // if host, call playerStateDidChange closure
        playerViewModel?.playerStateDidChange = { playerState in
            self.roomViewModel.updateRoomState(from: playerState)
        }
    }
}

extension RoomViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

extension RoomViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomViewModel.members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCollectionViewCell", for: indexPath) as! MemberCollectionViewCell
        cell.memberNameLabel.text = roomViewModel.members[indexPath.item]
        return cell
    }
}

extension RoomViewController: UICollectionViewDelegate {}

extension RoomViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionHeaderTitles = [
            "Now Playing",
            "Next in Queue",
            "From You"
        ]
        return sectionHeaderTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell", for: indexPath) as! TrackTableViewCell
        cell.trackNameLabel.text = roomViewModel?.currentTrack?.name
        cell.artistNameLabel.text = roomViewModel?.currentTrack?.artist
        return cell
    }
}

extension RoomViewController: UITableViewDelegate {}
