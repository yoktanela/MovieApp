//
//  SectionHeaderView.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 20.07.2021.
//

import Foundation
import UIKit

class SectionHeaderView: UIView {
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let topAnchor = titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5)
        let bottomAnchor = titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        let leftAnchor = titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16)
        let rightAnchor = titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        self.addConstraints([topAnchor, bottomAnchor, leftAnchor, rightAnchor])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTitle(title: String) {
        titleLabel.text = title
    }
}
