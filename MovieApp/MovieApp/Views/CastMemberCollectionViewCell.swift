//
//  CastMemberCollectionViewCell.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 21.07.2021.
//

import Foundation
import UIKit

class CastMemberCollectionViewCell: UICollectionViewCell {
    
    public let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(netHex: 0xF9F9F9)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.init(netHex: 0x7E7F9A).cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.init(netHex: 0x707070)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        lbl.sizeToFit()
        return lbl
    }()
    
    var roleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.init(netHex: 0x707070)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .light)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        lbl.sizeToFit()
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Container view constraints
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let topAnchor = containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        let bottomAnchor = containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        let leftAnchor = containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)
        let rightAnchor = containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        self.addConstraints([topAnchor, bottomAnchor, leftAnchor, rightAnchor])
        
        // nameLabel constraints
        containerView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let nameLabelTop = nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 3)
        let nameLabelLeft = nameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5)
        let nameLabelRight = nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5)
        self.addConstraints([nameLabelTop, nameLabelLeft, nameLabelRight])
        
        // roleLabel constraints
        containerView.addSubview(roleLabel)
        roleLabel.translatesAutoresizingMaskIntoConstraints = false
        let roleLabelTop = roleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1)
        let roleLabelBottom = roleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -3)
        let roleLabelLeft = roleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5)
        let roleLabelRight = roleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5)
        self.addConstraints([roleLabelTop, roleLabelBottom, roleLabelLeft, roleLabelRight])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
