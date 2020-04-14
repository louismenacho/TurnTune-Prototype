//
//  VideoThumbnail.swift
//  TurnTune
//
//  Created by Louis Menacho on 3/19/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct VideoThumbnail: Codable {
    var url: String?

    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
}
