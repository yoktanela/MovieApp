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
    
    public let videosLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(netHex: 0x707070)
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.text = "Videos"
        return label
    }()
    
    public let castLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(netHex: 0x707070)
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.text = "Cast"
        return label
    }()
    
    private var videoViewModel: VideoViewModel!
    private var videosCollectionView: UICollectionView!
    private var videosDataSource: CollectionViewDataSource<VideoCollectionViewCell,Video>!
    private var castViewModel: CastViewModel!
    private var castCollectionView: UICollectionView!
    private var castDataSource: CollectionViewDataSource<CastMemberCollectionViewCell,CastMember>!
    
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
        starRatingView.setRate(rating: Float(movie.voteAverage/2))
        let starRatingViewTop = starRatingView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 35)
        let starRatingViewLeft = starRatingView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10)
        let starRatingViewRight = starRatingView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 10)
        self.view.addConstraints([starRatingViewTop, starRatingViewLeft, starRatingViewRight])
        
        self.view.addSubview(voteAvarageLabel)
        voteAvarageLabel.text = String(describing: movie.voteAverage)
        voteAvarageLabel.translatesAutoresizingMaskIntoConstraints = false
        let voteAvarageLabelTopAnchor = voteAvarageLabel.topAnchor.constraint(equalTo: starRatingView.topAnchor, constant: 0)
        let voteAvarageLabelBottomAnchor = voteAvarageLabel.bottomAnchor.constraint(equalTo: starRatingView.bottomAnchor, constant: 0)
        let voteAvarageLabelRightAnchor = voteAvarageLabel.rightAnchor.constraint(lessThanOrEqualTo: self.view.rightAnchor, constant: -16)
        let voteAvarageLabelLeftAnchor = voteAvarageLabel.leftAnchor.constraint(equalTo: self.starRatingView.rightAnchor, constant: 10)
        self.view.addConstraints([voteAvarageLabelTopAnchor, voteAvarageLabelBottomAnchor, voteAvarageLabelRightAnchor, voteAvarageLabelLeftAnchor])
        
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
        self.view.addSubview(videosLabel)
        videosLabel.translatesAutoresizingMaskIntoConstraints = false
        let videosLabelTop = videosLabel.topAnchor.constraint(equalTo: overviewTextView.bottomAnchor, constant: 10)
        let videosLabelLeft = videosLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10)
        let videosLabelRight = videosLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 10)
        self.view.addConstraints([videosLabelTop, videosLabelLeft, videosLabelRight])
        
        let videoslayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        videoslayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 10)
        videoslayout.itemSize = CGSize(width: 90, height: 60)
        videoslayout.scrollDirection = .horizontal
        self.videosCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: videoslayout)
        videosCollectionView.backgroundColor = UIColor.white
        videosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(videosCollectionView)
        videosCollectionView.delegate = self
        let videosTableViewTop = videosCollectionView.topAnchor.constraint(equalTo: videosLabel.bottomAnchor, constant: 10)
        let videosTableViewLeft = videosCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10)
        let videosTableViewRight = videosCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0)
        let videosTableViewHeight = videosCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(70))
        self.view.addConstraints([videosTableViewTop, videosTableViewLeft, videosTableViewRight, videosTableViewHeight])
        videosCollectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "videoCell")
        
        // overviewLabel constraints
        self.view.addSubview(castLabel)
        castLabel.translatesAutoresizingMaskIntoConstraints = false
        let castLabelTop = castLabel.topAnchor.constraint(equalTo: videosCollectionView.bottomAnchor, constant: 10)
        let castLabelLeft = castLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10)
        let castLabelRight = castLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 10)
        self.view.addConstraints([castLabelTop, castLabelLeft, castLabelRight])
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
               layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 10)
        layout.itemSize = CGSize(width: 150, height: 55)
        self.castCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        castCollectionView.backgroundColor = UIColor.white
        castCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(castCollectionView)
        self.castCollectionView.delegate = self
        let castTableViewTop = castCollectionView.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 10)
        let castTableViewBottom = castCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20)
        let castTableViewLeft = castCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10)
        let castTableViewRight = castCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0)
        let castTableViewHeight = castCollectionView.heightAnchor.constraint(equalToConstant: 65)
        self.view.addConstraints([castTableViewTop, castTableViewBottom, castTableViewLeft, castTableViewRight, castTableViewHeight])
        castCollectionView.register(CastMemberCollectionViewCell.self, forCellWithReuseIdentifier: "castMemberCell")
        
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate() {
        self.videoViewModel = VideoViewModel(movieId: self.movie.id)
        self.videoViewModel.bindVideoViewModelToController = {
            self.updateDataSource()
        }
        
        self.castViewModel = CastViewModel(movieId: self.movie.id)
        self.castViewModel.bindCastViewModelToController = {
            self.updateDataForCastSource()
        }
    }
    
    func updateDataSource(){
        self.videosDataSource = CollectionViewDataSource(cellIdentifier: "videoCell", items: self.videoViewModel.videos, configureCell: { (cell, video) in
            cell.setVideoKey(key: video.key ?? "")
        })
        
        DispatchQueue.main.async {
            self.videosCollectionView.dataSource = self.videosDataSource
            self.videosCollectionView.reloadData()
        }
    }
    
    func updateDataForCastSource(){
        self.castDataSource = CollectionViewDataSource(cellIdentifier: "castMemberCell", items: self.castViewModel.cast, configureCell: { (cell, castMember) in
            cell.nameLabel.text = castMember.name
            cell.roleLabel.text = castMember.character
        })
        
        DispatchQueue.main.async {
            self.castCollectionView.dataSource = self.castDataSource
            self.castCollectionView.reloadData()
        }
    }
}

extension MovieDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == videosCollectionView {
            if indexPath.row < videoViewModel.videos.count {
                let video = videoViewModel.videos[indexPath.row]
                guard let videoKey = video.key else {
                    return
                }
                var playerVC = VideoPlayerViewController()
                playerVC.videoKey = videoKey
                self.navigationController?.present(playerVC, animated: true, completion: {
                    
                })
            }
        } else if collectionView == castCollectionView {
            if indexPath.row < castViewModel.cast.count {
                let castMember = castViewModel.cast[indexPath.row]
                let personVC = PersonDetailViewController()
                personVC.personId = castMember.id
                self.navigationController?.pushViewController(personVC, animated: true)
            }
        }
    }
}
