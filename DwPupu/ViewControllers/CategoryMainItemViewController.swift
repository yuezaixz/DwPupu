//
//  CategoryMainItemViewController.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/22.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Gifu

class CategoryMainItemViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Properties
    weak var collectionView: UICollectionView!
    
    let category = BehaviorRelay<Category>(value:Category())
    
    var topGifImageView:GIFImageView? = nil
    var currentUrlString:String? = nil

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let topGifImageView = self.topGifImageView, let urlStr = currentUrlString, let url = URL(string: urlStr) {
            topGifImageView.animate(withGIFURL: url){
                print(" (\(topGifImageView.frameCount) frames / \(String(format: "%.2f", topGifImageView.gifLoopDuration))s)")
            }
        }
    }
    
    func toggleAnimation(animation: Bool) {
        guard let topGifImageView = topGifImageView else { return }
        if !animation && topGifImageView.isAnimatingGIF {
            topGifImageView.stopAnimatingGIF()
        } else if animation && !topGifImageView.isAnimatingGIF {
            topGifImageView.startAnimatingGIF()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let topGifImageView = self.topGifImageView {
            topGifImageView.stopAnimatingGIF()
            topGifImageView.prepareForReuse()
        }
    }

    // MARK: - Initialize Appreaence
    private func _initUI() {
        _initCollectionView()
    }

    private func _initCollectionView() {
        let layout = DwFlowCollectionViewLayout()
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.collectionView = collectionView
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        collectionView.backgroundColor = UIColor(hex: "#F9F9F9")
        collectionView.collectionViewLayout = layout
        layout.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = false
        
        collectionView.register(UINib(nibName: "CategoryMainTopCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryMainTopCollectionViewCell")
        collectionView.register(UINib(nibName: "CategoryMainItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryMainItemCollectionViewCell")
    }

    // MARK: - CollectionView Delegate/DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.category.value.subCategorys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let subCategory = self.category.value.subCategorys[indexPath.row]
        
        if (indexPath.row == 0) {

            return collectionView.dequeueCell(ofType: CategoryMainTopCollectionViewCell.self, for: indexPath).then { cell in
                if let urlStr = Banner.linkUrlMap.value[category.value.id] {
                    if !urlStr.contains("gif") {
                        cell.imageView.kf.setImage(with: URL(string: "https://imgs.static.pupumall.com/\(urlStr)"))
                        cell.imageView.contentMode = .scaleAspectFill
                        cell.showImage(isGif: false)
                    } else {

                        self.topGifImageView = cell.gifImageView
                        self.currentUrlString = "https://imgs.static.pupumall.com/\(urlStr)"
                        
                        cell.showImage(isGif: true)
                    }
                }
            }
        } else {
            return collectionView.dequeueCell(ofType: CategoryMainItemCollectionViewCell.self, for: indexPath).then { cell in
                cell.nameLabel.text = subCategory.name
                cell.imageView.kf.setImage(with: URL(string: subCategory.imgUrl))
                cell.imageView.contentMode = .scaleAspectFill
            }
        }
    }
    
}

extension CategoryMainItemViewController: DwFlowCollectionViewLayoutDelegate {
    func waterFallLayout(_ waterFallLayout: DwFlowCollectionViewLayout, heightForItemAtIndexPath indexPath: Int) -> CGFloat {
        return indexPath == 0 ? 130:100
        
    }
    
    func isFullRowInWaterFallLayout(_ columnCountInWaterFallLayout: DwFlowCollectionViewLayout, inIndexPath indexPath: Int) -> Bool {
        return indexPath == 0 ? true:false
    }
    
    func columnCountInWaterFallLayout(_ waterFallLayout: DwFlowCollectionViewLayout) -> Int? {
        return 3
    }
}
