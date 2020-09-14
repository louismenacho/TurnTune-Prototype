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
    var playerViewModel: PlayerViewModel!
    var searcherViewModel: SearcherViewModel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = roomViewModel.roomCode
//        searchBar.delegate = self
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        tableView.dataSource = self
//        tableView.delegate = self
    }
}

//extension RoomViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        
//    }
//}
//
//extension RoomViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//    }
//}
//
//extension RoomViewController: UICollectionViewDelegate {}
//
//extension RoomViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//    }
//}
//
//extension RoomViewController: UITableViewDelegate {}
