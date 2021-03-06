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
    static let estimatedHeight: CGFloat = 180
    var myMovies: [Movie]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
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
        guard let count = myMovies?.count  else {
            return 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MyMoviesCollectionViewCell.self, for: indexPath)
        let item = myMovies?[indexPath.row]
        cell.configureCell(imagePath: item?.posterPath ?? "", title: item?.title ?? "")
        return cell
    }
    
}

extension MyMoviesTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: MyMoviesCollectionViewCell.estimatedWidth, height: MyMoviesCollectionViewCell.estimatedHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notifications.didSelectMyMovie.name, object: nil, userInfo: ["selectedMovie": myMovies?[indexPath.row] as Any])
    }
}
