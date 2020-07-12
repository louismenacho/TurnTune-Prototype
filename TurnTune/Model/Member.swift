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
    var uid: String
    var name: String
    
    init(uid: String, name: String) {
        self.uid = uid
        self.name = name
    }
}
