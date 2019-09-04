//
//  MovieClient.swift
//  MyMovie
//
//  Created by Unknown on 04/09/19.
//  Copyright © 2019 Nalfian. All rights reserved.
//

import Foundation

class MovieClient{
    
    static let apiKey = "221fbf2bcc939e0de03af53af4e1744a"
    
    enum EndPoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(MovieClient.apiKey)"
        
        case getNowPlaying
        case getUpcoming
        case search(String)
        case posterImage(String)
        
        var stringValue: String{
            switch self {
            case .getNowPlaying:
                return EndPoints.base + "/movie/now_playing" + EndPoints.apiKeyParam
            case .getUpcoming:
                return EndPoints.base + "/movie/upcoming" + EndPoints.apiKeyParam
            case .search(let keyword):
                return EndPoints.base + "/search/movie" + EndPoints.apiKeyParam + "&query=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
            case .posterImage(let path):
                return "https://image.tmdb.org/t/p/w500/" + path
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(FailureResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func nowPlaying(completion: @escaping ([Movie], Error?) -> Void) -> URLSessionDataTask {
        let task = taskForGETRequest(url: EndPoints.getNowPlaying.url, responseType: MovieResult.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
        return task
    }
    
    class func upcoming(completion: @escaping ([Movie], Error?) -> Void) -> URLSessionDataTask {
        let task = taskForGETRequest(url: EndPoints.getUpcoming.url, responseType: MovieResult.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
        return task
    }
    
    class func search(keyword: String, completion: @escaping ([Movie], Error?) -> Void) -> URLSessionDataTask {
        let task = taskForGETRequest(url: EndPoints.search(keyword).url, responseType: MovieResult.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
        return task
    }
    
    class func downloadPosterImage(path: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: EndPoints.posterImage(path).url) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
    
}
