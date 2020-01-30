//
//  FavoritViewController.swift
//  MyMovie
//
//  Created by Unknown on 03/09/19.
//  Copyright © 2019 Nalfian. All rights reserved.
//

import UIKit

class FavoritViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var db = MovieDB()
    var movies = [Movie]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.movies = db.reads()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension FavoritViewController: UITableViewDataSource, UITableViewDelegate {
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
