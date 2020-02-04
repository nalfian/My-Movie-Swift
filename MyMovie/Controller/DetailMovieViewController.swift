//
//  DetailMovieViewController.swift
//  MyMovie
//
//  Created by Unknown on 03/09/19.
//  Copyright © 2019 Nalfian. All rights reserved.
//

import UIKit

class DetailMovieViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UITextView!
    @IBOutlet weak var imageMovie: UIImageView!
    var buttonFavorit: UIBarButtonItem!
    var db = MovieDB()
    let networkManager = MovieMoya()
    let apiRequest = MovieAlamofire()
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        labelTitle.text = movie.title
        labelDescription.text = movie.overview
        
        setupNavbar()
        
        if let posterPath = movie.posterPath {
//            MovieClient.downloadPosterImage(path: posterPath) { data, error in
//                guard let data = data else {
//                    return
//                }
//                let image = UIImage(data: data)
//                self.imageMovie.image = image
//            }
            
            apiRequest.downloadImage(path: posterPath) { (data, error) in
                guard let data = data else {
                    return
                }
                let image = UIImage(data: data)
                self.imageMovie.image = image
            }
            
//            networkManager.downloadImage(path: posterPath) { (data, error) in
//                guard let data = data else {
//                    return
//                }
//                let image = UIImage(data: data)
//                self.imageMovie.image = image
//            }
        }
    }
    
    func setupNavbar() {
        buttonFavorit = UIBarButtonItem(image: UIImage(named: "Star"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(favoritePressed))
        navigationItem.rightBarButtonItem = buttonFavorit
        if db.isFavorite(id: movie.id){
            buttonFavorit.image = UIImage(named: "Favorite")
        } else{
            buttonFavorit.image = UIImage(named: "Star")
        }
    }
    
    @objc func favoritePressed() {
         if !db.isFavorite(id: movie.id){
            buttonFavorit.image = UIImage(named: "Favorite")
            db.insert(movie: movie)
        } else{
            buttonFavorit.image = UIImage(named: "Star")
            db.delete(id: movie.id)
        }
    }
}
