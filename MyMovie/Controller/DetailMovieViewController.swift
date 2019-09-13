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
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = movie.title
        labelDescription.text = movie.overview
        
        if let posterPath = movie.posterPath {
            MovieClient.downloadPosterImage(path: posterPath) { data, error in
                guard let data = data else {
                    return
                }
                let image = UIImage(data: data)
                self.imageMovie.image = image
            }
        }
    }

}
