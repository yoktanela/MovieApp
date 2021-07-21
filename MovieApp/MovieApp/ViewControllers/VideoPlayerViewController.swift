//
//  VideoPlayerViewController.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 21.07.2021.
//

import Foundation
import UIKit
import youtube_ios_player_helper

class VideoPlayerViewController: UIViewController {
    
    private var playerView: YTPlayerView = {
        let playerView = YTPlayerView()
        return playerView
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("close".localized, for: .normal)
        return button
    }()
    
    private var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            indicatorView.style = .large
        } else {
            // Fallback on earlier versions
        }
        indicatorView.color = .white
        return indicatorView
    }()
    
    var videoKey: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        self.view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        let indicatorViewCenterX = indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
        let indicatorViewCenterY = indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0)
        self.view.addConstraints([indicatorViewCenterX, indicatorViewCenterY])
        indicatorView.startAnimating()
        
        self.view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let closeButtonTop = closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10)
        let closeButtonLeft = closeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16)
        self.view.addConstraints([closeButtonTop, closeButtonLeft])
        closeButton.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
        
        self.view.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        let playerViewTop = playerView.topAnchor.constraint(equalTo: self.closeButton.bottomAnchor, constant: 10)
        let playerViewBottom = playerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        let playerViewLeft = playerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0)
        let playerViewRight = playerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0)
        self.view.addConstraints([playerViewTop, playerViewBottom, playerViewLeft, playerViewRight])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playerView.load(withVideoId: videoKey)
    }
    
    @objc func closeBtnClicked(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
}
