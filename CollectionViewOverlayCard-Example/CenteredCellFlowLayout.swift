//
//  CenteredCellFlowLayout.swift
//  CollectionViewOverlayCard-Example
//
//  Created by hyonsoo han on 2018. 2. 12..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import UIKit

public class CenteredCellFlowLayout: UICollectionViewFlowLayout {
    
    private var cache = [UICollectionViewLayoutAttributes]()
    private var defaultSpacing: CGFloat = 24
    private var defaultItemSize: CGSize? = nil
    
    private var contentHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.top + insets.bottom)
    }
    private var contentWidth: CGFloat = 0
    
    public override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    public override var itemSize: CGSize {
        get {
            guard let size = defaultItemSize else {
                return super.itemSize
            }
            return size
        }
        set {
            super.itemSize = newValue
            defaultItemSize = newValue
        }
    }
    
    public override var minimumInteritemSpacing: CGFloat {
        get {
            return defaultSpacing
        }
        set {
            super.minimumInteritemSpacing = newValue
            defaultSpacing = newValue
        }
    }
    
    public override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {
            return
        }
        cache.removeAll()
        //print("meme prepare-> \(collectionView.numberOfItems(inSection: 0))")
        
        let insets = collectionView.contentInset
        let itemWidth = (collectionView.bounds.size.width - insets.left - insets.right) * 0.8
        let itemHeight = min(contentHeight, itemWidth * 1.6) // 컨텐츠 높이를 벗어나지 않는 범위내에서 가로 크기에 비례
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        var itemOffsetX = (collectionView.bounds.width - itemSize.width) * 0.5
        let itemSizeOffset = itemOffsetX
        let offsetY = (collectionView.bounds.height - itemSize.height) * 0.5
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let frame = CGRect(x: itemOffsetX, y: offsetY, width: itemSize.width, height: itemSize.height)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
            
            itemOffsetX = frame.maxX + minimumInteritemSpacing
            contentWidth = frame.maxX + itemSizeOffset
        }
        
    }
    
    
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = self.collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        if collectionView.numberOfItems(inSection: 0) == 0 {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        
        if let first = layoutAttributesForItem(at: IndexPath(item: 0, section: 0)),
            let last = layoutAttributesForItem(at: IndexPath(item: collectionView.numberOfItems(inSection: 0) - 1, section: 0))
        {
            let left = (collectionView.frame.width - first.bounds.size.width) * 0.5
            let right = (collectionView.frame.width - last.bounds.size.width) * 0.5
            self.sectionInset = UIEdgeInsets(top: 0, left: left, bottom: 0, right: right)
        }
        
        let collectionViewSize = collectionView.bounds.size
        let proposedContentOffsetCenterX = proposedContentOffset.x + collectionViewSize.width * 0.5
        
        let proposedRect = collectionView.bounds
        //print("meme velocity: \(velocity.x)")
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        if let layoutAttributes = self.layoutAttributesForElements(in: proposedRect) {
            for attributes in layoutAttributes {
                if attributes.representedElementCategory != .cell {
                    continue
                }
                
                let currentOffset = collectionView.contentOffset
                let currentCenterX  = (currentOffset.x + collectionViewSize.width * 0.5)
                if (attributes.center.x <= currentCenterX && velocity.x > 0)
                    || (attributes.center.x >= currentCenterX && velocity.x < 0) {
                    continue
                }
                
                if candidateAttributes == nil {
                    candidateAttributes = attributes
                    continue
                }
                
                let lastCenterOffset = candidateAttributes!.center.x - proposedContentOffsetCenterX
                let centerOffset = attributes.center.x - proposedContentOffsetCenterX
                
                if fabsf(Float(centerOffset)) < fabsf(Float(lastCenterOffset)) {
                    candidateAttributes = attributes
                }
            }
        }
        if candidateAttributes != nil {
            return CGPoint(x: candidateAttributes!.center.x - collectionViewSize.width * 0.5, y: proposedContentOffset.y)
        } else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    //
    //    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    //        return true // required to transfom
    //    }
    
}
