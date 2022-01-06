//
//  PersonTableViewCell.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 21.07.2021.
//

import Foundation
import UIKit
import Kingfisher

class PersonTableViewCell: UITableViewCell {
    
    public let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(netHex: 0xF9F9F9)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.init(netHex: 0x7E7F9A).cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    public let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "person_placeholder")
        return imageView
    }()
    
    public let nameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.init(netHex: 0x707070)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(containerView)
        // Container view constraints
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let topAnchor = containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 1)
        let bottomAnchor = containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1)
        let leftAnchor = containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16)
        let rightAnchor = containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16)
        self.addConstraints([topAnchor, bottomAnchor, leftAnchor, rightAnchor])
        
        // profileImageView constraints
        containerView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        let imgViewTopAnchor = profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        let imgViewBottomAnchor = profileImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        let imgViewLeftAnchor = profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16)
        let imgViewWidthAnchor = profileImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.2)
        let imgViewHeightAnchor = profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 1.5)
        containerView.addConstraints([imgViewTopAnchor, imgViewBottomAnchor, imgViewLeftAnchor, imgViewWidthAnchor, imgViewHeightAnchor])
        
        // Name label constraints
        containerView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleTopAnchor = nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        let titleLeftAnchor = nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16)
        let titleRightAnchor = nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5)
        containerView.addConstraints([titleTopAnchor, titleLeftAnchor, titleRightAnchor])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProfileImage(path: String?){
        if let path = path, let url = URL(string: Constants.imageBaseURL + path) {
            let resource = ImageResource(downloadURL: url)
            profileImageView.kf.setImage(with: resource)
        }
    }
    
    func customizeCell(person: Person) {
        selectionStyle = UITableViewCell.SelectionStyle.none
        nameLabel.text = person.name
        setProfileImage(path: person.profilePath)
    }
}
