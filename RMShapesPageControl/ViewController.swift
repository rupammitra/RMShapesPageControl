//
//  ViewController.swift
//  RMShapesPageControl
//
//  Created by Rupam Mitra on 20/06/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 200)
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()

    private lazy var bottomPageControl: RMShapesPageControl = {
        let control = RMShapesPageControl()
        control.shape = .triangleUp
        control.indicatorSpacing = 16
        control.currentPageTintColor = .red
        control.pageIndicatorTintColor = .gray
        control.numberOfPages = 5
        control.currentPage = 0
        return control
    }()
    
    private lazy var leftPageControl: RMShapesPageControl = {
        let control = RMShapesPageControl()
        control.isVertical = true
        control.shape = .rectangleHorizontal
        control.indicatorSpacing = 16
        control.currentPageTintColor = .blue
        control.pageIndicatorTintColor = .gray
        control.numberOfPages = 5
        control.currentPage = 0
        return control
    }()

    private lazy var topPageControl: RMShapesPageControl = {
        let control = RMShapesPageControl()
        control.shape = .pentagon
        control.indicatorSpacing = 16
        control.currentPageTintColor = .green
        control.pageIndicatorTintColor = .gray
        control.numberOfPages = 5
        control.currentPage = 0
        return control
    }()

    private lazy var rightPageControl: RMShapesPageControl = {
        let control = RMShapesPageControl()
        control.isVertical = true
        control.shape = .hexagon
        control.indicatorSpacing = 16
        control.currentPageTintColor = .purple
        control.pageIndicatorTintColor = .gray
        control.numberOfPages = 5
        control.currentPage = 0
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupLayout()
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(bottomPageControl)
        view.addSubview(leftPageControl)
        view.addSubview(topPageControl)
        view.addSubview(rightPageControl)
        setupLayout()
    }

    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(200)
        }
        bottomPageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(30)
            make.width.equalTo(150)
        }
        leftPageControl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(30)
            make.height.equalTo(200)
        }
        topPageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(80)
            make.height.equalTo(30)
            make.width.equalTo(150)
        }
        rightPageControl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(30)
            make.height.equalTo(200)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bottomPageControl.numberOfPages
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor(hue: CGFloat(indexPath.item) / CGFloat(bottomPageControl.numberOfPages),
                                       saturation: 0.5,
                                       brightness: 0.9,
                                       alpha: 1)
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        bottomPageControl.currentPage = pageIndex
        leftPageControl.currentPage = pageIndex
        topPageControl.currentPage = pageIndex
        rightPageControl.currentPage = pageIndex
    }
}
