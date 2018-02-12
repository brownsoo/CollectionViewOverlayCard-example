//
//  CardView.swift
//  CollectionViewOverlayCard-Example
//
//  Created by hyonsoo han on 2018. 2. 12..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import Foundation
import UIKit

protocol RatioScrolled {
    var scrolledRatioX: CGFloat { get set }
    var scrolledRatioY: CGFloat { get set }
}

class CardView: UIView, RatioScrolled {
    
    var scrolledCenter: CGPoint = CGPoint()
    
    var scrolledRatioY: CGFloat = 0
    var scrolledRatioX: CGFloat = 0 {
        didSet {
            self.alpha = 1 - min(1, fabs(scrolledRatioX))
            self.frame = CGRect(
                x: basePosition.x + 100 * min(1.3, max(-1.3, scrolledRatioX)),
                y: basePosition.y,
                width: self.bounds.width,
                height: self.bounds.height)
        }
    }
    
    var basePosition = CGPoint(x: 200, y: 50)
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 140, height: 90))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        onInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        onInit()
    }
    
    private func onInit() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 10
        layer.borderColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.4).cgColor
        layer.borderWidth = 0.5
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 2, height: 7)
        layer.shadowRadius = 15
        layer.shadowOpacity = 0.3
        alpha = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
}
