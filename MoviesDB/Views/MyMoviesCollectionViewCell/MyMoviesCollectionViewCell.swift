//
//  MyMoviesCollectionViewCell.swift
//  MoviesDB
//
//  Created by Mohammed Oshiba on 2/23/19.
//

import UIKit

class MyMoviesCollectionViewCell: UICollectionViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var posterImageView: UIImageView! {
        didSet {
            posterImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    //MARK:- Constants&Variables
    static let nibName: String = "MyMoviesCollectionViewCellNib"
    
    func configureCell(imagePath: String, title: String) {
        
    }
    
}
