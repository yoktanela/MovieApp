//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 20.07.2021.
//

import Foundation
import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
    
    public let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(netHex: 0xF9F9F9)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.init(netHex: 0x7E7F9A).cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    public let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "movie_placeholder")
        return imageView
    }()
    
    public let titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.init(netHex: 0x707070)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    public let releaseLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.init(netHex: 0x707070)
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .light)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.text = "Release Date: "
        return lbl
    }()
    
    public let releaseDateLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.init(netHex: 0x707070)
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .light)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    public var starRatingView: StarRatingView = {
        let view = StarRatingView(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
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
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Container view constraints
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let topAnchor = containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 1)
        let bottomAnchor = containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1)
        let leftAnchor = containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16)
        let rightAnchor = containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16)
        self.addConstraints([topAnchor, bottomAnchor, leftAnchor, rightAnchor])
        
        // Title label constraints
        containerView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        let imgViewTopAnchor = posterImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        let imgViewBottomAnchor = posterImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        let imgViewLeftAnchor = posterImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16)
        let imgViewWidthAnchor = posterImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.2)
        let imgViewHeightAnchor = posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5)
        containerView.addConstraints([imgViewTopAnchor, imgViewBottomAnchor, imgViewLeftAnchor, imgViewWidthAnchor, imgViewHeightAnchor])
        
        // Title label constraints
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleTopAnchor = titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        let titleLeftAnchor = titleLabel.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: 16)
        let titleRightAnchor = titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5)
        containerView.addConstraints([titleTopAnchor, titleLeftAnchor, titleRightAnchor])
        
        // releaseLabel constraints
        containerView.addSubview(releaseLabel)
        releaseLabel.translatesAutoresizingMaskIntoConstraints = false
        let releaseLabelTopAnchor = releaseLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        let releaseLabelLeftAnchor = releaseLabel.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: 16)
        containerView.addConstraints([releaseLabelTopAnchor, releaseLabelLeftAnchor])
        
        // releaseDateLabel constraints
        containerView.addSubview(releaseDateLabel)
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        let releaseDateLabelTopAnchor = releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        let releaseDateLabelLeftAnchor = releaseDateLabel.leftAnchor.constraint(equalTo: releaseLabel.rightAnchor, constant: 2)
        let releaseDateLabelRightAnchor = releaseDateLabel.rightAnchor.constraint(lessThanOrEqualTo: containerView.rightAnchor, constant: -5)
        containerView.addConstraints([releaseDateLabelTopAnchor, releaseDateLabelLeftAnchor, releaseDateLabelRightAnchor])
        
        // starRatingView constraints
        containerView.addSubview(starRatingView)
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        let starRatingViewTopAnchor = starRatingView.topAnchor.constraint(greaterThanOrEqualTo: releaseLabel.bottomAnchor, constant: 5)
        let starRatingViewBottomAnchor = starRatingView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -10)
        let starRatingViewLeftAnchor = starRatingView.leftAnchor.constraint(equalTo: releaseLabel.leftAnchor, constant: 0)
        let starRatingViewRightAnchor = starRatingView.rightAnchor.constraint(lessThanOrEqualTo: containerView.rightAnchor, constant: -5)
        containerView.addConstraints([starRatingViewTopAnchor, starRatingViewBottomAnchor, starRatingViewLeftAnchor, starRatingViewRightAnchor])
        
        // starRatingView constraints
        containerView.addSubview(voteAvarageLabel)
        voteAvarageLabel.translatesAutoresizingMaskIntoConstraints = false
        let voteAvarageLabelTopAnchor = voteAvarageLabel.topAnchor.constraint(equalTo: starRatingView.topAnchor, constant: 0)
        let voteAvarageLabelBottomAnchor = voteAvarageLabel.bottomAnchor.constraint(equalTo: starRatingView.bottomAnchor, constant: 0)
        let voteAvarageLabelRightAnchor = voteAvarageLabel.rightAnchor.constraint(greaterThanOrEqualTo: containerView.rightAnchor, constant: -10)
        let voteAvarageLabelLeftAnchor = voteAvarageLabel.leadingAnchor.constraint(equalTo: starRatingView.trailingAnchor, constant: 10)
        containerView.addConstraints([voteAvarageLabelTopAnchor, voteAvarageLabelBottomAnchor, voteAvarageLabelLeftAnchor, voteAvarageLabelRightAnchor])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(text: String) {
        titleLabel.text = text
    }
    
    func setReleaseDate(text: String) {
        releaseLabel.text = text
    }
    
    func setPosterPath(text: String) {
        if let url = URL(string: Constants.imageBaseURL + text) {
            let resource = ImageResource(downloadURL: url)
            posterImageView.kf.setImage(with: resource)
        }
    }
    
    func setVoteAvarage(rate: Double) {
        voteAvarageLabel.text = String(describing: rate)
        starRatingView.setRate(rating: Float(rate)/2)
    }
}
