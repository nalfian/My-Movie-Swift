//
//  ApiRequestFetcher.swift
//  MyMovie
//
//  Created by Unknown on 04/02/20.
//  Copyright © 2020 Nalfian. All rights reserved.
//

import Foundation
import Alamofire

class MovieAlamofire {
    
    func getNowPlaying(completion: @escaping ([Movie], Error?) -> ()) {
        Alamofire
            .request(MovieClient.EndPoints.getNowPlaying.url)
            .response { response in
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let movie = try decoder.decode(MovieResult.self, from: data)
                    completion(movie.results, nil)
                } catch let error {
                    completion([], error)
                }
            }
    }

    func getUpcoming(completion: @escaping ([Movie], Error?) -> ()) {
        Alamofire
            .request(MovieClient.EndPoints.getUpcoming.url)
            .response { response in
                guard let data = response.data else { return }
                do {
                    let decode = JSONDecoder()
                    let movie = try decode.decode(MovieResult.self, from: data)
                    completion(movie.results, nil)
                } catch let error {
                    completion([], error)
                }
        }
    }

    func search(query: String, completion: @escaping ([Movie], Error?) -> ()) {
        Alamofire
            .request(MovieClient.EndPoints.search(query).url)
            .response { response in
                guard let data = response.data else { return }
                do {
                    let decode = JSONDecoder()
                    let movie = try decode.decode(MovieResult.self, from: data)
                    completion(movie.results, nil)
                } catch let error {
                    completion([], error)
                }
        }
    }

    func downloadImage(path: String, completion: @escaping (Data?, Error?) -> ()) {
        Alamofire
            .request(MovieClient.EndPoints.posterImage(path).url)
            .response { response in
                guard let data = response.data else { return }
                completion(data, nil)
        }
    }
    
}
