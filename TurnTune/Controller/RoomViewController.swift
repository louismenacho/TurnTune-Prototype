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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = roomViewModel.roomCode
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = prepareSearchController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MembersViewController" {
            let membersViewController = segue.destination as! MembersViewController
            membersViewController.membersViewModel = MembersViewModel(roomViewModel.membersCollectionRef)
        }
        if segue.identifier == "PlayerViewController" {
            let playerViewController = segue.destination as! PlayerViewController
            playerViewController.playerViewModel = PlayerViewModel(roomViewModel.playerStateCollectionRef)
        }
    }
    
    private func prepareSearchController() -> UISearchController {
        let searchResultsViewController = prepareSearchResultsViewController()
        let searchController = UISearchController(searchResultsController: searchResultsViewController)
        searchController.searchResultsUpdater = searchResultsViewController
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = "Search Track"
        searchController.delegate = self
        return searchController
    }
    
    private func prepareSearchResultsViewController() -> SearchResultsViewController {
        guard let searchResultsViewController = storyboard?.instantiateViewController(identifier: "SearchResultsViewController") as? SearchResultsViewController else {
            fatalError("Could not instantiate SearchResultsViewController")
        }
        searchResultsViewController.searcherViewModel = SearcherViewModel()
        return searchResultsViewController
    }
}

extension RoomViewController: UISearchControllerDelegate {
    func presentSearchController(_ searchController: UISearchController) {
        searchController.showsSearchResultsController = true
    }
}
