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
    static let nibName: String = "MovieTableViewCellNib"
    
    func configureCell(imagePath: String, title: String, overViewText: String, date: String) {
        titleLabel.text = title
        overViewLabel.text = overViewText
        dateLabel.text = date
        guard let imagePath = URL(string: "\(Urls.Path.poster.absolutePath)\(imagePath)") else {
            posterImageView.image = UIImage.init(named: "poster-placeholder")
            return
        }
        posterImageView.fetchImage(imagePath)
    }
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
