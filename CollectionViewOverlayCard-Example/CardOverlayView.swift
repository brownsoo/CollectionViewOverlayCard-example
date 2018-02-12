//
//  CardOverlayView.swift
//  CollectionViewOverlayCard-Example
//
//  Created by hyonsoo han on 2018. 2. 12..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import Foundation
import UIKit

class CardOverlayView: UIView, CollectionViewCenterRatioScrolled {
    
    private var cards: [Int: CardView] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        onInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        onInit()
    }
    
    private func onInit() {
        backgroundColor = UIColor.clear
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hit = super.hitTest(point, with: event)
        if hit == self {
            return nil
        }
        return hit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for card in cards {
            card.value.basePosition = CGPoint(
                x: self.bounds.width * 0.6,
                y: self.bounds.height * 0.3)
        }
    }
    
    func attachCard(_ collectionView: UICollectionView, at: IndexPath) {
        cards[at.row] = CardView()
        cards[at.row]?.basePosition = CGPoint(
            x: self.bounds.width * 0.6,
            y: self.bounds.height * 0.3)
        addSubview(cards[at.row]!)
        updateScrolled(collectionView)
    }
    
    func detachCard(_ collectionView: UICollectionView, at: IndexPath) {
        cards[at.row]?.removeFromSuperview()
        cards[at.row] = nil
        updateScrolled(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, ratioScrolled: CGPoint, at indexPath: IndexPath?) {
        if let at = indexPath {
            cards[at.row]?.scrolledRatioX = ratioScrolled.x
            cards[at.row]?.scrolledRatioY = ratioScrolled.y
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, centerScrolled: CGPoint, at indexPath: IndexPath?) {
        if let at = indexPath {
            //print("at: \(at.row)  \(centerScrolled.x)   \(cards[at.row] != nil)")
            cards[at.row]?.scrolledCenter = centerScrolled
            setNeedsDisplay() // FIXME remove this
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let context = UIGraphicsGetCurrentContext() {
            context.setStrokeColor(UIColor.yellow.cgColor)
            context.setLineWidth(2)
            context.move(to: CGPoint(x: 0, y: 0))
            context.addRect(rect)
            
            context.beginPath()
            context.setStrokeColor(UIColor.red.cgColor)
            for card in cards {
                let center = card.value.scrolledCenter
                context.move(to: CGPoint(x: center.x, y: center.y - 40))
                context.addLine(to: CGPoint(x: center.x, y: center.y + 40))
                context.move(to: CGPoint(x: center.x - 40, y: center.y))
                context.addLine(to: CGPoint(x: center.x + 40, y: center.y))
            }
            context.strokePath()
        }
    }
}
