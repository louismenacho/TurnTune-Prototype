//
//  RoomInfo.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/16/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

class RoomInfo {
    var code: String = ""
    var host: String = ""
    var token: Token?
    
    init(code: String? = nil) {
        if let code = code {
            self.code = code
        }
    }
    
    init(host: String? = nil) {
        if let host = host {
            self.host = host
        }
    }
}
