//
//  VideoCollectionViewCell.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 21.07.2021.
//

import Foundation
import UIKit
import Kingfisher

class VideoCollectionViewCell: UICollectionViewCell {
    
    var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.red.cgColor
        return imageView
    }()
    
    var playImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.red.cgColor
        imageView.image = UIImage(named: "play_icon")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        
        self.addSubview(thumbnailImageView)
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        let thumbnailTop = thumbnailImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let thumbnailBottom = thumbnailImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        let thumbnailLeft = thumbnailImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let thumbnailRight = thumbnailImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        self.addConstraints([thumbnailTop, thumbnailBottom, thumbnailLeft, thumbnailRight])
        
        self.addSubview(playImageView)
        playImageView.translatesAutoresizingMaskIntoConstraints = false
        let playImageViewWidth = playImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1)
        let playImageViewHeight = playImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1)
        let centerX = playImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let centerY = playImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        self.addConstraints([playImageViewWidth, playImageViewHeight, centerX, centerY])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        thumbnailImageView.kf.cancelDownloadTask()
    }
    
    func setVideoKey(key: String) {
        if let url = URL(string: Constants.thumbnailBaseURL + key + "/0.jpg") {
            let resource = ImageResource(downloadURL: url)
            thumbnailImageView.kf.setImage(with: resource)
        }
    }
}
