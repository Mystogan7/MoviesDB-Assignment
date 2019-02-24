//
//  ViewController.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/19/19.
//

import UIKit

enum MyMoviesDisplayMode {
    case noItems
    case showItems
}

enum MoviesListDisplayMode {
    case fetchedMovies
    case displayableMovie
}

class MoviesViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.register(nib: UINib(nibName: MovieTableViewCell.nibName, bundle: .main), withCellClass: MovieTableViewCell.self)
            tableView.register(nib: UINib(nibName: MyMoviesTableViewCell.nibName, bundle: .main), withCellClass: MyMoviesTableViewCell.self)
            tableView.register(nib: UINib(nibName:MoviesHeaderView.nibName, bundle: .main), withHeaderFooterViewClass: MoviesHeaderView.self)
        }
    }
    
    //MARK:- Variables&Constants
    let fetchMoviesService = FetchMoviesService()
    fileprivate let myMoviesSection = 0
    fileprivate let moviesSection = 1
    private let cacher = Caching()
    var myMoviesDisplayMode: MyMoviesDisplayMode = .noItems
    var moviesListDisplayMode: MoviesListDisplayMode = .fetchedMovies

    
    var fetchedMovies: [Movie]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadSections([1], with: .automatic)
            }
        }
    }
    
    var displayableMovie: Movie? {
        didSet {
            if moviesListDisplayMode == .fetchedMovies {
                moviesListDisplayMode = .displayableMovie
            } else {
                moviesListDisplayMode = .fetchedMovies
            }
            DispatchQueue.main.async {
                self.tableView.reloadSections([1], with: .automatic)
            }
        }

    }
    var mySavedMovies = [Movie]() {
        didSet {
            if mySavedMovies.isEmpty {
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
        fetchMovieslist()
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
                return fetchedMovies?.count ?? 0
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
                cell.mySavedMovies = self.mySavedMovies
                return cell
            }
        case moviesSection:
            let cell = tableView.dequeueReusableCell(withClass: MovieTableViewCell.self, for: indexPath)
            var item: Movie?
            switch moviesListDisplayMode {
            case .fetchedMovies:
                 item = fetchedMovies![indexPath.row]
            case .displayableMovie:
                 item = displayableMovie
            }
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
            header.route = { self.navigateToAddMoviesViewController() }
            header.showAddMovieSection(true)
            switch myMoviesDisplayMode {
               case .noItems:
                header.setLabelText(text: "Add your movies!")
            case .showItems:
                header.setLabelText(text: "My Movies")
            }
        case moviesSection:
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
            return MovieTableViewCell.estimatedHeight
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MoviesHeaderView.estimatedHeight
    }
    
}

extension MoviesViewController {
    
    func fetchMovieslist() {
        fetchMoviesService.start(parameters: ["page": "1"]) { (result) in
            switch result {
            case .success(let model):
                self.fetchedMovies = (model as? Movies)?.movies
            case .failure(let error):
                print(error.description)
            }
        }
    }
    
    @objc func updateMyMovies(notification: Notification) {
        let savedMovie = notification.userInfo?["movie"] as! Movie
        self.mySavedMovies.append(savedMovie)
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
}

