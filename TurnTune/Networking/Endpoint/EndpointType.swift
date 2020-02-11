//
//  EndpointType.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

typealias HttpHeaders = [String: String]
typealias HttpParameters = [String: Any]

protocol EndpointType {
    var host: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: HttpHeaders? { get }
    var parameters: HttpParameters? { get }
    var url: URL? { get }
}
