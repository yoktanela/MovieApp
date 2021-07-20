//
//  StarRatingView.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 20.07.2021.
//

import Foundation
import UIKit

class StarRatingView: UIView {
    
    var starImageViews: [UIImageView] = []
    private var starCount = 5
    private var padding: CGFloat = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for i in 0..<starCount {
            let starImageView = UIImageView(frame: CGRect(x: (25 + padding)*CGFloat(i) , y: 0, width: 25, height: 25))
            starImageView.image = UIImage(named: "star")
            starImageViews.append(starImageView)
            self.addSubview(starImageView)
        }
    }
    
    func setRate(rating: Float) {
        for i in 0..<self.starImageViews.count {
            let imageView = self.starImageViews[i]
            
            if rating>=Float(i+1) {
                imageView.layer.mask = nil
                imageView.isHidden = false
            } else if rating>Float(i) && rating<Float(i+1) {
                // Create a mask layer for full image
                let maskLayer = CALayer()
                // Calculate the mask width as a fraction of the full image
                let maskWidth = CGFloat(rating - Float(i)) * imageView.frame.size.width
                let maskHeight = imageView.frame.size.height
                // Set the mask frame
                maskLayer.frame = CGRect(x: 0, y: 0, width: maskWidth , height: maskHeight )
                // The mask layer needs a colour to show the full image
                maskLayer.backgroundColor = UIColor.black.cgColor
                // Set the full image view's mask and unhide it
                imageView.layer.mask = maskLayer
                imageView.isHidden = false
            }
        // Hide the full rating image if rating is less than index
        else {
          imageView.layer.mask = nil
          imageView.isHidden = true
        }
      }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
