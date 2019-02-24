//
//  MoviesHeaderView.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/23/19.
//

import UIKit

class MoviesHeaderView: UITableViewHeaderFooterView {
    
    //Mark: Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
                self.isUserInteractionEnabled = true
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NavigateToAddingMovieController))
                self.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var plusIconImage: UIImageView!
    
    //Mark: Variables&Constants
    static let nibName: String = "MoviesHeaderViewNib"
    static let estimatedHeight: CGFloat = 40
    var route: (() -> Void)?
    
    func setLabelText(text: String) {
        headerLabel.text = text
    }
    
    @objc func NavigateToAddingMovieController() {
        if let route = route {
            route()
        }
    }
    
    func showAddMovieSection(_ show: Bool) {
        plusIconImage.isHidden = !show
    }
}
