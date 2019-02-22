//
//  Extensions+View.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/22/19.
//

import UIKit

extension UIView {
    
    func dropCardShadow(shadowRadius: CGFloat? = nil, shadowOpacity: Float? = nil) {
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = shadowOpacity ?? 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = shadowRadius ?? 2
    }
}



