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
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = roomViewModel.roomCode
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Track"
        definesPresentationContext = true
        
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

extension RoomViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searcherViewModel.search(query: searchController.searchBar.searchTextField.text!) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
        if searchController.isActive {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive {
            return nil
        } else {
            let sectionHeaderTitles = ["Now Playing", "Next in Queue", "From You"]
            return sectionHeaderTitles[section]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searcherViewModel.searchResult.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell", for: indexPath) as! TrackTableViewCell
        
        if searchController.isActive {
            cell.trackNameLabel.text = searcherViewModel.searchResult[indexPath.row].name
            cell.artistNameLabel.text = searcherViewModel.searchResult[indexPath.row].artist
        } else {
            cell.trackNameLabel.text = roomViewModel?.currentTrack?.name
            cell.artistNameLabel.text = roomViewModel?.currentTrack?.artist
        }
        
        return cell
    }
}

extension RoomViewController: UITableViewDelegate {}
