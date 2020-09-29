//
//  MembersViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/19/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

class MembersViewModel {
    
    private var members = [String]()
    private var membersCollectionRef: CollectionReference
    
    var count: Int { members.count }
    var member: (Int) -> String { { self.members[$0] } }
    var membersDidChange: (() -> Void)?
    
    init(_ membersCollectionRef: CollectionReference) {
        self.membersCollectionRef = membersCollectionRef
        addMembersListener()
    }
    
    private func addMembersListener() {
        membersCollectionRef.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print(error)
                return
            }
            guard let query = querySnapshot else {
                print("No query")
                return
            }
            self.members = query.documents.map({ JSON($0.data())["displayName"].stringValue })
            self.membersDidChange?()
        }
    }
}
