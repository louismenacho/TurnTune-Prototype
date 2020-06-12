//
//  HTTPError.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/31/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation

public enum HTTPError: Error {
    case invalidURL
    case noResponse
    case noData
    case failedRequest(_ response: HTTPResponse)
}

extension HTTPError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL in request"
        case .noResponse:
            return "No response"
        case .noData:
            return "No data"
        case .failedRequest(let response):
            return "\(response.details.statusCode) "+"\(HTTPURLResponse.localizedString(forStatusCode: response.details.statusCode))\n" +
            "\((try? JSONSerialization.jsonObject(with: response.data, options: [])) ?? "")"
        }
    }
}

extension HTTPError {
    var response: HTTPResponse? {
        switch self {
        case .failedRequest(let response):
            return response
        default:
            return nil
        }
    }
}
