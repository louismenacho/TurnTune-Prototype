//
//  Member.swift
//  TurnTune
//
//  Created by Louis Menacho on 7/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation
import FirebaseAuth

struct Member: Codable {
    var name: String
    var uid: String
    
    init() {
        self.name = Auth.auth().currentUser!.displayName!
        self.uid = Auth.auth().currentUser!.uid
    }
}
