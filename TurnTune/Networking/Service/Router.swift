//
//  Router.swift
//  TurnTune
//
//  Created by Louis Menacho on 2/9/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

protocol Router: class {
    associatedtype Endpoint: EndpointType
    func request<T: Codable>(_ route: Endpoint, completion: @escaping (Result<T, Error>) -> Void)
}
