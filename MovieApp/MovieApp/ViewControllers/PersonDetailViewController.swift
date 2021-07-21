//
//  PersonDetailViewController.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 21.07.2021.
//

import Foundation
import UIKit
import Kingfisher

class PersonDetailViewController: UIViewController {
    
    var personId: Int!
    var personViewModel: PersonViewModel!
    
    var profileImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        let profileTop = profileImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20)
        let profileLeft = profileImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16)
        let profileWidth = profileImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.35)
        let profileHeight = profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 1.5)
        self.view.addConstraints([profileTop, profileLeft, profileWidth, profileHeight])
        
        personViewModel = PersonViewModel(personId: personId)
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate() {
        personViewModel.profilePath.bind { [weak self] profilePath in
            if let profilePath = profilePath, let url = URL(string: Constants.imageBaseURL + profilePath) {
                let resource = ImageResource(downloadURL: url)
                self?.profileImageView.kf.setImage(with: resource)
            }
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
