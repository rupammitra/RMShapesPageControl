//
//  ViewController.swift
//  RMPageControlDemo
//
//  Created by Rupam Mitra on 20/08/16.
//  Copyright © 2016 Rupam Mitra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pageCollectionView: UICollectionView!
    @IBOutlet var pageControl: [RMShapesPageControl]!
    
    @IBOutlet var squarePageControl: RMShapesPageControl!
    @IBOutlet var circlePageControl: RMShapesPageControl!
    @IBOutlet var trianglePositivePageControl: RMShapesPageControl!
    @IBOutlet var triangleNegativePageControl: RMShapesPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        squarePageControl.numberOfPages = pageCollectionView.numberOfItems(inSection: 0)
        circlePageControl.numberOfPages = pageCollectionView.numberOfItems(inSection: 0)
        trianglePositivePageControl.numberOfPages = pageCollectionView.numberOfItems(inSection: 0)
        triangleNegativePageControl.numberOfPages = pageCollectionView.numberOfItems(inSection: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let page = scrollView.contentOffset.x / scrollView.frame.width
        squarePageControl.currentPage = Int(page)
        circlePageControl.currentPage = Int(page)
        trianglePositivePageControl.currentPage = Int(page)
        triangleNegativePageControl.currentPage = Int(page)
    }
}

extension UIColor {
    
    static func randomColor() -> UIColor? {
        
        let randomRed: CGFloat = CGFloat(drand48())
        let randomGreen: CGFloat = CGFloat(drand48())
        let randomBlue: CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}
