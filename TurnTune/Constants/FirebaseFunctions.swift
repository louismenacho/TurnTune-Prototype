//
//  FirebaseFunctions.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/12/20.
//  Copyright © 2020 Louis Menacho. All rights reserved.
//

import Foundation
import Firebase

extension Functions {
    func spotifyClientSecret(completion: @escaping (String) -> Void) {
        httpsCallable("SpotifyClientSecret").call { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let clientSecret = (result?.data as? [String: String])?["client_secret"] {
                completion(clientSecret)
            }
        }
    }
}
