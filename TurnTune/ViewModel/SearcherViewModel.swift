//
//  SearcherViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/14/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

class SearcherViewModel {
    
    private var searcher: Searcher
    var searchResult: [Track] { searcher.searchResult }
    
    init() {
        searcher = Searcher()
        generateAccessToken()
    }
    
    func generateAccessToken() {
        Functions.functions().spotifyClientSecret { clientSecret in
            let url = URL(string: "https://accounts.spotify.com/api/token")!
            let bodyParameters = ["grant_type": "client_credentials"]
            let base64Credentials = (SpotifyApp.configuration.clientID+":"+clientSecret).data(using: .utf8)!.base64EncodedString()
            
            var urlComponents = URLComponents()
            urlComponents.queryItems = bodyParameters.map({
                URLQueryItem(name: $0.key, value: "\($0.value)".addingPercentEncoding(withAllowedCharacters: .alphanumerics))
            })
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
            urlRequest.addValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
            urlRequest.httpMethod = "POST"
            
            URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let json = try? JSON(data: data!) {
                    self.searcher.accessToken = json["access_token"].string!
                }
            }).resume()
        }
    }
    
    func search(query: String, completion: @escaping () -> Void) {
        let url = URL(string: "https://api.spotify.com/v1/search")!
        let queryParameters = ["q": query, "type": "track"]
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = queryParameters.map({
            URLQueryItem(name: $0.key, value: "\($0.value)")
        })
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.addValue("Bearer \(searcher.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let json = try? JSON(data: data!) {
                print(json)
                self.searcher.searchResult = json["tracks"]["items"].arrayValue.map({ Track($0) })
                completion()
            }
        }).resume()
        
        searcher.history.append(query)
    }
}
