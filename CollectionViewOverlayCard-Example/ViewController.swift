//
//  ViewController.swift
//  CollectionViewOverlayCard-Example
//
//  Created by hyonsoo han on 2018. 2. 12..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout {
    
    private var cardsView: UICollectionView!
    private let cardOverlay = CardOverlayView()
    private let source:[Int] = [1,2,3,4,5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = CenteredCellFlowLayout()
        layout.scrollDirection = .horizontal
        
        cardsView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.view.addSubview(cardsView)
        cardsView.translatesAutoresizingMaskIntoConstraints = false
        cardsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        cardsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        cardsView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 36).isActive = true
        cardsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16).isActive = true
        cardsView.layer.borderColor = UIColor.black.cgColor
        cardsView.layer.borderWidth = 1
        cardsView.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        cardsView.delegate = self
        cardsView.dataSource = self
        cardsView.register(NumberCell.self, forCellWithReuseIdentifier: "Number")
        
        self.view.addSubview(cardOverlay)
        cardOverlay.frame = cardsView.frame
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Number", for: indexPath) as! NumberCell
        cell.label.text = "\(source[indexPath.row])"
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate
    // Tells the delegate that the specified cell is about to be displayed in the collection view
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cardOverlay.attachCard(collectionView, at: indexPath)
    }
    
    //Tells the delegate that the specified cell was removed from the collection view.
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cardOverlay.detachCard(collectionView, at: indexPath)
    }
    
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        cardOverlay.updateScrolled(cardsView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.center.x + scrollView.contentOffset.x,
                             y: scrollView.center.y + scrollView.contentOffset.y)
        guard let path = self.cardsView.indexPathForItem(at: center) else {
            return
        }
        cardOverlay.updateScrolled(cardsView)
        print("scrolling end decelerating   \(path.row)")
    }
}

