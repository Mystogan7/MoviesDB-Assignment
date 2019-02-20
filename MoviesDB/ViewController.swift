//
//  ViewController.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/19/19.
//

import UIKit

class MoviesViewController: UIViewController {

    let fetchMoviesService = FetchMoviesService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMoviesService.start(parameters: ["page": "1"]) { (result) in
            debugPrint(result)
        }
    }


}

