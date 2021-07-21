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
    
    public let movieCreditsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(netHex: 0x707070)
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.text = "Movie Credits"
        return label
    }()
    
    private var moviesCollectionView: UICollectionView!
    private var castDataSource: CollectionViewDataSource<CastMemberCollectionViewCell,Movie>!
    
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
        let biographyTextViewLeft = biographyTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16)
        let biographyTextViewRight = biographyTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16)
        self.view.addConstraints([biographyTextViewTop, biographyTextViewLeft, biographyTextViewRight])
        
        // movieCreditsLabel constraints
        self.view.addSubview(movieCreditsLabel)
        movieCreditsLabel.translatesAutoresizingMaskIntoConstraints = false
        let movieCreditsLabelTop = movieCreditsLabel.topAnchor.constraint(equalTo: biographyTextView.bottomAnchor, constant: 10)
        let movieCreditsLabelLeft = movieCreditsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10)
        let movieCreditsLabelRight = movieCreditsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 10)
        self.view.addConstraints([movieCreditsLabelTop, movieCreditsLabelLeft, movieCreditsLabelRight])
        
        // moviesCollectionView constraints
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
               layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 10)
        layout.itemSize = CGSize(width: 180, height: 55)
        self.moviesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        moviesCollectionView.backgroundColor = UIColor.white
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(moviesCollectionView)
        moviesCollectionView.delegate = self
        let moviesCollectionViewTop = moviesCollectionView.topAnchor.constraint(equalTo: movieCreditsLabel.bottomAnchor, constant: 10)
        let moviesCollectionViewBottom = moviesCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20)
        let moviesCollectionViewLeft = moviesCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10)
        let moviesCollectionViewRight = moviesCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0)
        let moviesCollectionViewHeight = moviesCollectionView.heightAnchor.constraint(equalToConstant: 65)
        self.view.addConstraints([moviesCollectionViewTop, moviesCollectionViewBottom, moviesCollectionViewLeft, moviesCollectionViewRight, moviesCollectionViewHeight])
        moviesCollectionView.register(CastMemberCollectionViewCell.self, forCellWithReuseIdentifier: "castCell")
        
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
            self?.castDataSource = CollectionViewDataSource(cellIdentifier: "castCell", items: movieCredits ?? [], configureCell: { (cell, cast) in
                cell.nameLabel.text = cast.originalTitle
                cell.roleLabel.text = cast.character
            })
            
            DispatchQueue.main.async {
                self?.moviesCollectionView.dataSource = self?.castDataSource
                self?.moviesCollectionView.reloadData()
            }
        }
    }
}

extension PersonDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var movies = personViewModel.movieCredits.value
        if indexPath.row < movies?.count ?? 0 {
            let movie = movies?[indexPath.row]
            guard let movieId = movie?.id else {
                return
            }
            var movieDetailVC = MovieDetailViewController()
            // TODO: there is only id for movie we need getmovie api
            
        }
    }
}
