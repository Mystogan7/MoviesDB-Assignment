//
//  MyMoviesTableViewCell.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/23/19.
//

import UIKit

class MyMoviesTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(nib: UINib(nibName: MyMoviesCollectionViewCell.nibName, bundle: .main), withCellClass: MyMoviesCollectionViewCell.self)
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    //MARK:- Constants&Variables
    static let nibName: String = "MyMoviesTableViewCellNib"
    static let estimatedHeight: CGFloat = 120
    fileprivate let defaultCell = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MyMoviesTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MyMoviesCollectionViewCell.self, for: indexPath)
        guard indexPath.row != defaultCell else {
            cell.movieTitleLabel.text = ""
            cell.posterImageView.image = nil
            return cell
        }
        return cell
    }
    
}

extension MyMoviesTableViewCell: UICollectionViewDelegate {
    
}
