//
//  UpComingViewController.swift
//  MyMovie
//
//  Created by Unknown on 03/09/19.
//  Copyright © 2019 Nalfian. All rights reserved.
//

import Foundation
import UIKit

class UpcomingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [Movie]()
    var task: URLSessionDataTask?
    let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.getUpcoming { (movies, error) in
            if let error = error {
                print(error)
                return
            }
            self.movies = movies
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
//        task = MovieClient.upcoming() { movieResult, error in
//            self.movies = movieResult
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
    }
    
}

extension UpcomingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell")!
        let movie = movies[indexPath.row]
        
        cell.textLabel?.text = movie.title
        cell.imageView?.image = UIImage(named: "PosterPlaceholder")
        if let posterPath = movie.posterPath {
            MovieClient.downloadPosterImage(path: posterPath) { data, error in
                guard let data = data else {
                    return
                }
                let image = UIImage(data: data)
                cell.imageView?.image = image
                cell.setNeedsLayout()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let movie = movies[indexPath.row]
        self.performSegue(withIdentifier: "showDetail", sender: movie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailVC = segue.destination as? DetailMovieViewController
            detailVC?.movie = sender as? Movie
        }
    }
}
