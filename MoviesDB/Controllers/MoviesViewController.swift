//
//  ViewController.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/19/19.
//

import UIKit

class MoviesViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.register(nib: UINib(nibName: "MovieTableViewCellNib", bundle: .main), withCellClass: MovieTableViewCell.self)
        }
    }
    
    //MARK:- Variables&Constants
    let fetchMoviesService = FetchMoviesService()
    
    var movies: [Movie]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovieslist()
    }

}

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (movies?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MovieTableViewCell.self, for: indexPath)
        let item = movies![indexPath.row]
        cell.configureCell(poster: item.posterPath!, title: item.title!, overViewText: item.overview!, date: item.releaseDate!)
        return cell
    }
}

extension MoviesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MovieTableViewCell.estimatedHeight
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
}

