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
    
    let biographyLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(netHex: 0x707070)
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.text = "Biography"
        return label
    }()
    
    let biographyTextView : UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.init(netHex: 0x707070)
        textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textView.textAlignment = .left
        return textView
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
        
        // biographyLabel constraints
        self.view.addSubview(biographyLabel)
        biographyLabel.translatesAutoresizingMaskIntoConstraints = false
        let biographyLabelTop = biographyLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10)
        let biographyLabelLeft = biographyLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10)
        let biographyLabelRight = biographyLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 10)
        self.view.addConstraints([biographyLabelTop, biographyLabelLeft, biographyLabelRight])
        
        // overviewTextView constraints
        self.view.addSubview(biographyTextView)
        biographyTextView.translatesAutoresizingMaskIntoConstraints = false
        let biographyTextViewTop = biographyTextView.topAnchor.constraint(equalTo: biographyLabel.bottomAnchor, constant: 5)
        let biographyTextViewBottom = biographyTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16)
        let biographyTextViewLeft = biographyTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16)
        let biographyTextViewRight = biographyTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16)
        self.view.addConstraints([biographyTextViewTop, biographyTextViewLeft, biographyTextViewRight,biographyTextViewBottom])
        
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
            self?.biographyTextView.text = biography
        }
        
        personViewModel.movieCredits.bind { [weak self] movieCredits in
            // update movie credits
        }
    }
    
}
