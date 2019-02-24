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
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    //MARK:- Constants&Variables
    static let nibName: String = "MyMoviesCollectionViewCellNib"
    static let estimatedHeight: CGFloat = 160
    static let estimatedWidth: CGFloat = 120
    
    func configureCell(imagePath: String, title: String) {
        self.movieTitleLabel.text = title
        DispatchQueue.main.async {
            self.posterImageView.image = imagePath.toImage()
        }
    }
    
}
