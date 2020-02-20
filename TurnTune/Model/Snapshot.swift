//
//  Snapshot.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/19/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct Snapshot: Codable {
    var id: String

    enum CodingKeys: String, CodingKey {
        case id = "snapshot_id"
    }
}
