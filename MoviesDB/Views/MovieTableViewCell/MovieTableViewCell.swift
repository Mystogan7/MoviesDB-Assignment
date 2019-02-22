//
//  MovieTableViewCell.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/20/19.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    //MARK: Outlets
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
    @IBOutlet weak var contentTextView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    //MARK: Variables&Constants
    static let estimatedHeight: CGFloat = 600
    
    func configureCell(poster: String, title: String, overViewText: String, date: String) {
        titleLabel.text = title
        overViewLabel.text = overViewText
        dateLabel.text = date
        posterImageView.fetchImage(URL(string: "\(Urls.Path.poster.absolutePath)\(poster)")!)
    }
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
