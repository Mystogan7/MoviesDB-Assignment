//
//  Extensions+UIImageView.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/21/19.
//

import UIKit
import Foundation

extension UIImageView {
    func fetchImage(_ url: URL) {
        NetworkManager.shared.loadImage(from: url) { (image) in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
