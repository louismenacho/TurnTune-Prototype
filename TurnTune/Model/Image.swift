//
//  Image.swift
//  TurnTune
//
//  Created by Louis Menacho on 3/18/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

struct Image: Codable {
    var height: Int
    var url: String
    var width: Int

    enum CodingKeys: String, CodingKey {
        case height = "height"
        case url = "url"
        case width = "width"
    }
}
