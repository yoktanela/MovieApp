//
//  ViewController.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 19.07.2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MainViewController: UIViewController {

    var searchController: UISearchController!
    var moviesTableView: UITableView!
    var activityIndicator: UIActivityIndicatorView!
    
    private let disposeBag = DisposeBag()
    private var moviesViewModel: MoviesViewModel!
    private var dataSource : MovieTableViewDataSource<MovieTableViewCell,Movie>!
    private var page: Int = 1
    private var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create tableview
        self.moviesTableView = UITableView(frame: self.view.frame)
        self.view.addSubview(moviesTableView)
        let topConstraint = self.moviesTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        self.view.addConstraints([topConstraint])
        moviesTableView.delegate = self
        moviesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        moviesTableView.register(PersonTableViewCell.self, forCellReuseIdentifier: "PersonTableViewCell")
        moviesTableView.separatorStyle = .none
        
        self.activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        self.moviesViewModel = MoviesViewModel()
        
        self.moviesViewModel.running
            .asDriver()
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        createSearchBar()
        callToViewModelForUIUpdate()
    }

    func createSearchBar() {
        self.searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        extendedLayoutIncludesOpaqueBars = true
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            let searchBar = self.searchController.searchBar
            searchBar.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9803921569, blue: 0.9843137255, alpha: 1)
            searchBar.backgroundImage = UIImage()
            moviesTableView.tableHeaderView = searchBar
        }

        searchController.searchBar.setImage(UIImage(named: "search_icon"), for:  UISearchBar.Icon.search, state: .normal)
        searchController.searchBar.tintColor = UIColor(netHex: 0x006ED5)
        if #available(iOS 11.0, *) {
            let topConstraint = self.moviesTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
            self.view.addConstraints([topConstraint])
        } else {
            // Fallback on earlier versions
        }
        
        let searchInput = searchController.searchBar.rx.text
            .orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .filter{ $0.count > 0 }
            .asObservable()
        
        searchInput.subscribe(onNext: { [weak self] text in
            self?.moviesViewModel.callFuntionToGetSearchResults(searchText: text)
            self?.inSearchMode = true
        })
        .disposed(by: disposeBag)
        
        let cancelSearch =  searchController.searchBar.rx.text
            .filter{ $0?.count == 0 }
            .asObservable()
        
        let cancel = Observable.merge(
            cancelSearch.map { _ in true },
            searchController.searchBar.rx.cancelButtonClicked.map{_ in true}.asObservable()
        )
        .startWith(false)
        .asObservable()
        
        cancel.subscribe(onNext: { [weak self] cancel in
            self?.moviesViewModel.clearSearchResults()
            self?.inSearchMode = false
        })
        .disposed(by: disposeBag)
    }
    
    func callToViewModelForUIUpdate() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(
            configureCell: { (_, tableView, indexPath, element) in
                switch element {
                case .movie:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
                    cell.customizeCell(movie: element.get() as! Movie)
                    return cell
                case .person:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell", for: indexPath) as! PersonTableViewCell
                    cell.customizeCell(person: element.get() as! Person)
                    return cell
                default:
                    return UITableViewCell()
                }
            },
            titleForHeaderInSection: { dataSource, sectionIndex in
                return dataSource[sectionIndex].header
            }
        )

        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
          return true
        }

        dataSource.canMoveRowAtIndexPath = { dataSource, indexPath in
          return true
        }
        
        let sections = BehaviorRelay<[SectionOfCustomData]>.init(value: [])
        
        self.moviesViewModel.media
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { media in
                let movies = media.filter{ $0.get() is Movie }
                let people = media.filter{ $0.get() is Person }
                
                var sectionList: [SectionOfCustomData] = []
                if movies.count != 0 {
                    sectionList.append(SectionOfCustomData(header: "Movies", items: movies))
                }
                if people.count != 0 {
                    sectionList.append(SectionOfCustomData(header: "People", items: people))

                }
                sections.accept(sectionList)
            })
            .disposed(by: disposeBag)
        
        sections
          .bind(to: moviesTableView.rx.items(dataSource: dataSource))
          .disposed(by: disposeBag)
        
        self.moviesTableView.rx.modelSelected(Media.self)
            .subscribe(onNext: { media in
                switch media {
                case .movie:
                    let movieDetailViewController = MovieDetailViewController()
                    movieDetailViewController.movieId = (media.get() as! Movie).id
                    self.navigationController?.pushViewController(movieDetailViewController, animated: true)
                case .person:
                    let personDetailViewController = PersonDetailViewController()
                    personDetailViewController.personId = (media.get() as! Person).id
                    self.navigationController?.pushViewController(personDetailViewController, animated: true)
                case .others:
                    return
                }
            })
            .disposed(by: disposeBag)
    }
}

extension MainViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !inSearchMode){
            page += 1
            moviesViewModel.callFunctionToGetMovieData(page: page)
        }
    }
}

struct SectionOfCustomData {
  var header: String
  var items: [Item]
}

extension SectionOfCustomData: SectionModelType {
  typealias Item = Media

   init(original: SectionOfCustomData, items: [Item]) {
    self = original
    self.items = items
  }
}
