//
//  NoResultView.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 21.07.2021.
//

import Foundation
import UIKit

class NoResultView: UIView {
    
    public let titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.init(netHex: 0x707070)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.text = "No Results to show."
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let xcenter = titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        let ycenter = titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        self.addConstraints([xcenter, ycenter])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
