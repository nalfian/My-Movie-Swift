//
//  NetworkManager.swift
//  MyMovie
//
//  Created by Unknown on 04/02/20.
//  Copyright © 2020 Nalfian. All rights reserved.
//

import Foundation
import Moya

class NetworkManager: Networkable {
    
    var provider = MoyaProvider<MovieApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    func getUpcoming(completion: @escaping ([Movie], Error?) -> ()) {
        provider.request(.getUpcoming) { (response) in
            switch response.result {
            case .failure(let error):
                completion([], error)
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let movie = try decoder.decode(MovieResult.self, from: value.data)
                    completion(movie.results, nil)
                } catch let error {
                    completion([], error)
                }
            }
        }
    }
    
    func search(query: String, completion: @escaping ([Movie], Error?) -> ()) {
        provider.request(.search(query)) { (response) in
            switch response.result {
            case .failure(let error):
                completion([], error)
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let movie = try decoder.decode(MovieResult.self, from: value.data)
                    completion(movie.results, nil)
                } catch let error {
                    completion([], error)
                }
            }
        }
    }
    
    func getNowPlaying(completion: @escaping ([Movie], Error?) -> ()) {
        provider.request(.getNowPlaying) { (response) in
            switch response.result {
            case .failure(let error):
                completion([], error)
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let movie = try decoder.decode(MovieResult.self, from: value.data)
                    completion(movie.results, nil)
                } catch let error {
                    completion([], error)
                }
            }
        }
    }
    
    
}
