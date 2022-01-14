//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 20.07.2021.
//

import Foundation
import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class MovieDetailViewController: UIViewController {

    private let disposeBag = DisposeBag()
    var movieId: Int!
    
    var coverImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.image = UIImage(named: "movie_placeholder")
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
    
    private var videosCollectionView: UICollectionView!
    private var videosDataSource: CollectionViewDataSource<VideoCollectionViewCell,Video>!
    private var castCollectionView: UICollectionView!
    private var castDataSource: CollectionViewDataSource<CastMemberCollectionViewCell,CastMember>!
    private var movieViewModel: MovieViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        // coverImageView constraints
        self.view.addSubview(coverImageView)
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        let imgViewTop = coverImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        let imgViewLeft = coverImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0)
        let imgViewRight = coverImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0)
        let imgViewHeight = coverImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25)
        self.view.addConstraints([imgViewTop, imgViewLeft, imgViewRight, imgViewHeight])
        
        // starRatingView contraints
        self.view.addSubview(starRatingView)
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        let starRatingViewTop = starRatingView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 35)
        let starRatingViewLeft = starRatingView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10)
        let starRatingViewRight = starRatingView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 10)
        self.view.addConstraints([starRatingViewTop, starRatingViewLeft, starRatingViewRight])
        
        self.view.addSubview(voteAvarageLabel)
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
        let castTableViewTop = castCollectionView.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 10)
        let castTableViewBottom = castCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20)
        let castTableViewLeft = castCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10)
        let castTableViewRight = castCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0)
        let castTableViewHeight = castCollectionView.heightAnchor.constraint(equalToConstant: 65)
        self.view.addConstraints([castTableViewTop, castTableViewBottom, castTableViewLeft, castTableViewRight, castTableViewHeight])
        castCollectionView.register(CastMemberCollectionViewCell.self, forCellWithReuseIdentifier: "castMemberCell")
        
        self.movieViewModel = MovieViewModel(movieId: movieId)
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate() {
        movieViewModel.originalTitle.asDriver()
            .drive(self.navigationItem.rx.title)
            .disposed(by: disposeBag)

        movieViewModel.backdropPath.flatMap{ path -> Observable<ImageResource> in
            guard let url = URL(string: Constants.imageBaseURL + path) else {
                return Observable.empty()
            }
            return .just(ImageResource(downloadURL: url))
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] imgSource in
            self?.coverImageView.kf.setImage(with: imgSource)
        })
        .disposed(by: disposeBag)
        
        let voteAverage = movieViewModel.voteAverage.asDriver()
        voteAverage.map { String(describing: $0) }
            .drive(self.voteAvarageLabel.rx.text)
            .disposed(by: disposeBag)
        voteAverage.drive(self.starRatingView.rx.rating)
            .disposed(by: disposeBag)
    
        movieViewModel.overview.asDriver()
            .drive(self.overviewTextView.rx.text)
            .disposed(by: disposeBag)
        
        movieViewModel.videos.asObservable()
            .bind(to: self.videosCollectionView.rx.items) { (tableView, row, element) in
                let cell = self.videosCollectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: IndexPath(row: row, section: 0)) as! VideoCollectionViewCell
                cell.setVideoKey(key: element.key ?? "")
                return cell
            }
            .disposed(by: disposeBag)
        
        self.videosCollectionView.rx.modelSelected(Video.self)
            .subscribe(onNext: { video in
                guard let videoKey = video.key else {
                    return
                }
                let playerVC = VideoPlayerViewController()
                playerVC.videoKey = videoKey
                self.navigationController?.present(playerVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        movieViewModel.cast.asObservable()
            .bind(to: self.castCollectionView.rx.items) { (tableView, row, element) in
                let cell = self.castCollectionView.dequeueReusableCell(withReuseIdentifier: "castMemberCell", for: IndexPath(row: row, section: 0)) as! CastMemberCollectionViewCell
                cell.nameLabel.text = element.name
                cell.roleLabel.text = element.character
                return cell
            }
            .disposed(by: disposeBag)
        
        self.castCollectionView.rx.modelSelected(CastMember.self)
            .subscribe(onNext: { castMember in
                let personVC = PersonDetailViewController()
                personVC.personId = castMember.id
                self.navigationController?.pushViewController(personVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
