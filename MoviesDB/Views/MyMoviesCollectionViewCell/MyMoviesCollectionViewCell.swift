//
//  MyMoviesCollectionViewCell.swift
//  MoviesDB
//
//  Created by Mohammed Oshiba on 2/23/19.
//

import UIKit

class MyMoviesCollectionViewCell: UICollectionViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var mainView: UIView! {
        didSet {
            mainView.dropCardShadow()
        }
    }
    @IBOutlet weak var posterImageView: UIImageView! {
        didSet {
            posterImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    //MARK:- Constants&Variables
    static let nibName: String = "MyMoviesCollectionViewCellNib"
    static let estimatedHeight: CGFloat = 140
    static let estimatedWidth: CGFloat = 100
    
    func configureCell(imagePath: String, title: String) {
        self.movieTitleLabel.text = title
        DispatchQueue.main.async {
            self.posterImageView.image = imagePath.toImage()
        }
    }
    
}
