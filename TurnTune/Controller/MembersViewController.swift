//
//  MembersViewController.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/19/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import UIKit

class MembersViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension MembersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomViewModel.members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCollectionViewCell", for: indexPath) as! MemberCollectionViewCell
        cell.memberNameLabel.text = roomViewModel.members[indexPath.item]
        return cell
    }
}

extension MembersViewController: UICollectionViewDelegate {}
