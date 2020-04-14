//
//  Snapshot.swift
//  TurnTune
//
//  Created by Louis Menacho on 3/19/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct Snapshot: Codable {
    var snapshotId: String

    enum CodingKeys: String, CodingKey {
        case snapshotId = "snapshot_id"
    }
}
