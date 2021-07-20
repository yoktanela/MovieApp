//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 20.07.2021.
//

import Foundation
import UIKit

class MovieDetailViewController: UIViewController {

    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = movie.originalTitle
    }
}
