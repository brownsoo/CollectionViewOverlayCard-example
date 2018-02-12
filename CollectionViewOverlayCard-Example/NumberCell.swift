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
        translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
