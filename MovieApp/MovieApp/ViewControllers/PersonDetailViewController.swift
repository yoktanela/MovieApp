//
//  PersonDetailViewController.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 21.07.2021.
//

import Foundation
import UIKit

class PersonDetailViewController: UIViewController {
    
    var personId: Int!
    var personViewModel: PersonViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        personViewModel = PersonViewModel(personId: personId)
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate() {
        personViewModel.profilePath.bind { [weak self] profilePath in
            // set image to image view
        }
           
        personViewModel.name.bind { [weak self] name in
            self?.navigationItem.title = name
        }
        
        personViewModel.biography.bind { [weak self] biography in
            // update biography text
        }
        
        personViewModel.movieCredits.bind { [weak self] movieCredits in
            // update movie credits
        }
    }
    
}
