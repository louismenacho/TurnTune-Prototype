//
//  SearchResultsViewController.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/19/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    var searcherViewModel: SearcherViewModel!

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
    }
}

extension SearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searcherViewModel.search(query: searchController.searchBar.searchTextField.text!) {
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searcherViewModel.searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let track = searcherViewModel.searchResult[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsTableViewCell", for: indexPath) as! SearchResultsTableViewCell
        cell.trackNameLabel.text = track.name
        cell.artistNameLabel.text = track.artist
        return cell
    }
}
