//
//  ViewController.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/19/19.
//

import UIKit

enum MyMoviesViewMode {
    case noItems
    case showItems
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
    var showMode: MyMoviesViewMode = .noItems

    
    var movies: [Movie]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var myMovies: [Movie]? {
        didSet {
            if let myMovies = myMovies, myMovies.isEmpty { showMode = .noItems } else {
                showMode = .showItems
            }
        }
    }
    
    //MARK:- Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovieslist()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        loadMyMoviesFromCacher()
    }
    
    

}

extension MoviesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case myMoviesSection:
            switch showMode {
            case .noItems:
                return 0
            case .showItems:
                return 1
            }
        case moviesSection:
            return movies?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case myMoviesSection:
            switch showMode {
            case .noItems:
                return UITableViewCell()
            case .showItems:
                let cell = tableView.dequeueReusableCell(withClass: MyMoviesTableViewCell.self, for: indexPath)
                return cell
            }
        case moviesSection:
            let cell = tableView.dequeueReusableCell(withClass: MovieTableViewCell.self, for: indexPath)
            let item = movies![indexPath.row]
            cell.configureCell(imagePath: item.posterPath!, title: item.title!, overViewText: item.overview!, date: item.releaseDate!)
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
            switch showMode {
               case .noItems:
                header.setLabelText(text: "Add your movies!")
            case .showItems:
                header.setLabelText(text: "My Movies")
            }
        case moviesSection:
            header.setLabelText(text: "All Movies")
            header.route = { }
            header.showAddMovieSection(false)
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
                self.movies = (model as? Movies)?.movies
            case .failure(let error):
                print(error.description)
            }
        }
    }
    
    func loadMyMoviesFromCacher() {
        let cacher = Caching()
        cacher.pathComponent = "My movies"
        cacher.load(key: cacher.pathComponent) { (data) in
            guard let data = data else { return }
            do {
                let _ = try JSONDecoder().decode(Movie.self, from: data) as? Movie
            } catch {
                
            }
        }
    }
    
    func navigateToAddMoviesViewController() {
        let storyboard = UIStoryboard(name: "Main",  bundle: .main)
        let addNewMoviesViewController = storyboard.instantiateViewController(withIdentifier: "AddNewMoviesViewController") as! AddNewMoviesViewController
        self.navigationController?.pushViewController(addNewMoviesViewController, animated: true)
    }
}

