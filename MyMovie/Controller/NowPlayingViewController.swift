//
//  ViewController.swift
//  MyMovie
//
//  Created by Unknown on 28/08/19.
//  Copyright © 2019 Nalfian. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var movies = [Movie]()
    var task : URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        task = MovieClient.nowPlaying() { movieResult, error in
            self.movies = movieResult
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    
    }
}

extension NowPlayingViewController: UITableViewDataSource, UITableViewDelegate{
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
        if let posterPath = movie.posterPath{
            MovieClient.downloadPosterImage(path: posterPath){ data, error in
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
}

