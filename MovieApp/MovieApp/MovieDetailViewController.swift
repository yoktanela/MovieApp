//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 20.07.2021.
//

import Foundation
import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {

    var movie: Movie!
    
    var coverImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    public var starRatingView: StarRatingView = {
        let view = StarRatingView(frame: CGRect.zero)
        return view
    }()
    
    public let voteAvarageLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.init(netHex: 0x707070)
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.text = "10.0"
        return lbl
    }()
    
    public let overviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(netHex: 0x707070)
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.text = "Overview"
        return label
    }()
    
    public let overviewTextView : UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.init(netHex: 0x707070)
        textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textView.textAlignment = .left
        return textView
    }()
    
    public let castLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(netHex: 0x707070)
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.text = "Cast"
        return label
    }()
    
    var castCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = movie.originalTitle
        
        // coverImageView constraints
        self.view.addSubview(coverImageView)
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        if let backdropPath = movie.backdropPath, let url = URL(string: Constants.imageBaseURL + backdropPath) {
            let resource = ImageResource(downloadURL: url)
            coverImageView.kf.setImage(with: resource)
        }
        let imgViewTop = coverImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        let imgViewLeft = coverImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0)
        let imgViewRight = coverImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0)
        let imgViewHeight = coverImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25)
        self.view.addConstraints([imgViewTop, imgViewLeft, imgViewRight, imgViewHeight])
        
        // starRatingView contraints
        self.view.addSubview(starRatingView)
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        starRatingView.setRate(rating: Float(movie.voteAverage))
        let starRatingViewTop = starRatingView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 35)
        let starRatingViewLeft = starRatingView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10)
        let starRatingViewRight = starRatingView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 10)
        self.view.addConstraints([starRatingViewTop, starRatingViewLeft, starRatingViewRight])
        
        // overviewLabel constraints
        self.view.addSubview(overviewLabel)
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        let overviewLabelTop = overviewLabel.topAnchor.constraint(equalTo: starRatingView.bottomAnchor, constant: 10)
        let overviewLabelLeft = overviewLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10)
        let overviewLabelRight = overviewLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 10)
        self.view.addConstraints([overviewLabelTop, overviewLabelLeft, overviewLabelRight])
        
        // overviewTextView constraints
        self.view.addSubview(overviewTextView)
        overviewTextView.text = movie.overview
        overviewTextView.translatesAutoresizingMaskIntoConstraints = false
        let overviewTextViewTop = overviewTextView.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 5)
        let overviewTextViewLeft = overviewTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16)
        let overviewTextViewRight = overviewTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16)
        
        self.view.addConstraints([overviewTextViewTop, overviewTextViewLeft, overviewTextViewRight])
        
        // overviewLabel constraints
        self.view.addSubview(castLabel)
        castLabel.translatesAutoresizingMaskIntoConstraints = false
        let castLabelTop = castLabel.topAnchor.constraint(equalTo: overviewTextView.bottomAnchor, constant: 10)
        let castLabelLeft = castLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10)
        let castLabelRight = castLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 10)
        self.view.addConstraints([castLabelTop, castLabelLeft, castLabelRight])
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
               layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        self.castCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        castCollectionView.backgroundColor = UIColor.white
        castCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(castCollectionView)
        let castTableViewTop = castCollectionView.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 10)
        let castTableViewBottom = castCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20)
        let castTableViewLeft = castCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10)
        let castTableViewRight = castCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 10)
        let castTableViewHeight = castCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2)
        self.view.addConstraints([castTableViewTop, castTableViewBottom, castTableViewLeft, castTableViewRight, castTableViewHeight])
    }
}
