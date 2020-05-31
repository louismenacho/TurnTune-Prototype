//
//  APIEndpoint.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/30/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

protocol APIEndpoint {
    var baseURL: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: HTTPParameters? { get }
    var contentType: HTTPHeaderValue? { get }
}
