//
//  MembersViewController.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/19/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import UIKit

class MembersViewController: UIViewController {
    
    var membersViewModel: MembersViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        membersViewModel.membersDidChange = { self.collectionView.reloadData() }
    }
}

extension MembersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return membersViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCollectionViewCell", for: indexPath) as! MemberCollectionViewCell
        cell.memberNameLabel.text = membersViewModel.member(indexPath.item)
        return cell
    }
}

extension MembersViewController: UICollectionViewDelegate {}
