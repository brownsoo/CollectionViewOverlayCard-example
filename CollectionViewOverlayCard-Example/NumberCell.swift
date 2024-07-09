//
//  NumberCell.swift
//  CollectionViewOverlayCard-Example
//
//  Created by hyonsoo han on 2018. 2. 12..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import UIKit

class NumberCell: UICollectionViewCell {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
