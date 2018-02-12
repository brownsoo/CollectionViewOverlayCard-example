//
//  CollectionViewRatioScrolled.swift
//  CollectionViewOverlayCard-Example
//
//  Created by hyonsoo han on 2018. 2. 12..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewRatioScrolled {
    func updateScrolled(_ collectionView: UICollectionView)
    func collectionView(_ collectionView: UICollectionView, ratioScrolled: CGPoint, at indexPath: IndexPath?)
    func collectionView(_ collectionView: UICollectionView, centerScrolled: CGPoint, at indexPath: IndexPath?)
}

protocol CollectionViewCenterRatioScrolled: CollectionViewRatioScrolled {}
extension CollectionViewCenterRatioScrolled {
    func updateScrolled(_ collectionView: UICollectionView) {
        guard let sv = collectionView.superview else {
            return
        }
        let window = collectionView.bounds.size.width * 0.5
        let collectionCenter = collectionView.center
        var cellCenter: CGPoint
        var xRatio: CGFloat
        var yRatio: CGFloat
        var indexPath: IndexPath?
        for cell in collectionView.visibleCells {
            cellCenter = sv.convert(cell.center, from: collectionView)
            xRatio = (cellCenter.x - collectionCenter.x) / window
            yRatio = (cellCenter.y - collectionCenter.y) / window
            indexPath = collectionView.indexPath(for: cell)
            self.collectionView(collectionView, centerScrolled: cellCenter, at: indexPath)
            self.collectionView(collectionView,
                                ratioScrolled: CGPoint(x: xRatio, y: yRatio),
                                at: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, centerScrolled: CGPoint, at indexPath: IndexPath?) {
        //
    }
}
