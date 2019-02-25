//
//  ViewController.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/19/19.
//

import UIKit

fileprivate enum MyMoviesDisplayMode {
    case noItems
    case showItems
}

enum MoviesListDisplayMode {
    case fetchedMovies
    case displayableMovie
}

fileprivate enum CellType {
    case movie
    case loading
}

class MoviesViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.register(nib: UINib(nibName: MovieTableViewCell.nibName, bundle: .main), withCellClass: MovieTableViewCell.self)
            tableView.register(nib: UINib(nibName: MyMoviesTableViewCell.nibName, bundle: .main), withCellClass: MyMoviesTableViewCell.self)
            tableView.register(nib: UINib(nibName:MoviesHeaderView.nibName, bundle: .main), withHeaderFooterViewClass: MoviesHeaderView.self)
            tableView.register(nib: UINib(nibName: LoadingIndicatorTableViewCell.nibName, bundle: .main), withCellClass: LoadingIndicatorTableViewCell.self)
            fetchMovieslist()
        }
    }
    
    //MARK:- Variables&Constants
    var fetchMoviesService = FetchMoviesService()
    fileprivate let myMoviesSection = 0
    fileprivate let moviesSection = 1
    fileprivate var currentPage = 1
    fileprivate var isCurrentlyFetching = false
    private let cacher = Caching()
    fileprivate var myMoviesDisplayMode: MyMoviesDisplayMode = .noItems
    fileprivate var moviesListDisplayMode: MoviesListDisplayMode = .fetchedMovies
    fileprivate var cellType: CellType = .movie

    
    private var fetchedMovies: [Movie]? {
        didSet {
            guard currentPage == 1 else { return }
            DispatchQueue.main.async {
                self.tableView.reloadSections([1], with: .automatic)
            }
        }
    }
    private var displayableMovie: Movie? {
        didSet {
            switchMoviesListDisplayMode()
            DispatchQueue.main.async {
                self.tableView.reloadSections([1], with: .automatic)
            }
        }

    }
    private var myMovies = [Movie]() {
        didSet {
            if myMovies.isEmpty {
                myMoviesDisplayMode = .noItems
            } else {
                myMoviesDisplayMode = .showItems
                DispatchQueue.main.async {
                    self.tableView.reloadSections([0], with: .automatic)
                }
            }
        }
    }
    
    //MARK:- Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}

extension MoviesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case myMoviesSection:
            switch myMoviesDisplayMode {
            case .noItems:
                return 0
            case .showItems:
                return 1
            }
        case moviesSection:
            switch moviesListDisplayMode {
            case .fetchedMovies:
                guard let count = fetchedMovies?.count else {
                    return 0
                }
                //+Indicator Cell
                return count + 1
            case .displayableMovie:
                return 1
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case myMoviesSection:
            switch myMoviesDisplayMode {
            case .noItems:
                return UITableViewCell()
            case .showItems:
                let cell = tableView.dequeueReusableCell(withClass: MyMoviesTableViewCell.self, for: indexPath)
                cell.myMovies = self.myMovies
                return cell
            }
        case moviesSection:
            //Handle loading activity.
            if indexPath.row == fetchedMovies?.count {
                cellType = .loading
            } else {
                cellType = .movie
            }
            guard cellType != .loading else {
                let loader = tableView.dequeueReusableCell(withClass: LoadingIndicatorTableViewCell.self, for: indexPath)
                return loader
            }
            
            //Handle displaying movies.
            let cell = tableView.dequeueReusableCell(withClass: MovieTableViewCell.self, for: indexPath)
            var item: Movie?
            switch moviesListDisplayMode {
            case .fetchedMovies:
                item = fetchedMovies?[indexPath.row]
            case .displayableMovie:
                 item = displayableMovie
            }
            //For proper reuse of cell content.
            cell.posterImageView.image = nil
            cell.configureCell(imagePath: item?.posterPath ?? "", title: item?.title ?? "", overViewText: item?.overview ?? "", date: item?.releaseDate ?? "", display: moviesListDisplayMode)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  tableView.dequeueReusableHeaderFooterView(withClass: MoviesHeaderView.self)
        switch section {
        case myMoviesSection:
            //For UI-Testing
            header.accessibilityIdentifier = "header_0"
            header.isAccessibilityElement = true
            
            header.route = { self.navigateToAddMoviesViewController() }
            header.showAddMovieSection(true)
            switch myMoviesDisplayMode {
               case .noItems:
                header.setLabelText(text: "Add your movies!")
            case .showItems:
                header.setLabelText(text: "My Movies")
            }
        case moviesSection:
            //For UI-Testing
            header.accessibilityIdentifier = ""
            header.isAccessibilityElement = true
            switch moviesListDisplayMode {
            case .fetchedMovies:
                header.setLabelText(text: "All Movies")
                header.route = { }
                header.showAddMovieSection(false)
            case .displayableMovie:
                header.setLabelText(text: displayableMovie?.title ?? "")
                header.route = { }
                header.showAddMovieSection(false)
            }
            
        default:
            return nil
        }
        return header
    }
    
}

extension MoviesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case myMoviesSection:
            return MyMoviesTableViewCell.estimatedHeight
        case moviesSection:
            switch cellType {
            case .movie:
                return MovieTableViewCell.estimatedHeight
            case .loading:
                return LoadingIndicatorTableViewCell.estimatedHeight
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cellType == .loading, !isCurrentlyFetching {
            fetchMovieslist()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MoviesHeaderView.estimatedHeight
    }
    
}

extension MoviesViewController {
    
    func fetchMovieslist() {
        isCurrentlyFetching = true
        fetchMoviesService.start(parameters: ["page": "\(currentPage)"]) { (result) in
            switch result {
            case .success(let model):
                self.isCurrentlyFetching = false
                guard self.currentPage == 1 else {
                    (model as? Movies)?.movies?.forEach({ (newMovie) in
                        self.fetchedMovies?.append(newMovie)
                    })
                    DispatchQueue.main.async {
                        UIView.performWithoutAnimation {
                            self.tableView.reloadSections([1], with: .none)
                        }
                    }
                    self.currentPage += 1
                    return
                }
                self.fetchedMovies = (model as? Movies)?.movies
                self.currentPage += 1
            case .failure(let error):
                self.isCurrentlyFetching = false
                print(error.description)
            }
        }
    }
    
    @objc func updateMyMovies(notification: Notification) {
        let savedMovie = notification.userInfo?["movie"] as! Movie
        self.myMovies.append(savedMovie)
    }
    
    @objc func displayMySelectedMovie(notification: Notification) {
        let selectedMovie = notification.userInfo?["selectedMovie"] as! Movie
        self.displayableMovie = selectedMovie
    }
    
    func bindNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateMyMovies), name: Notifications.didSaveMovie.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(displayMySelectedMovie), name: Notifications.didSelectMyMovie.name, object: nil)
    }
    
    func navigateToAddMoviesViewController() {
        let storyboard = UIStoryboard(name: "Main",  bundle: .main)
        let addNewMoviesViewController = storyboard.instantiateViewController(withIdentifier: "AddNewMoviesViewController") as! AddNewMoviesViewController
        self.navigationController?.pushViewController(addNewMoviesViewController, animated: true)
    }
    
    func switchMoviesListDisplayMode() {
        if moviesListDisplayMode == .fetchedMovies {
            moviesListDisplayMode = .displayableMovie
        } else {
            moviesListDisplayMode = .fetchedMovies
        }
    }
}

