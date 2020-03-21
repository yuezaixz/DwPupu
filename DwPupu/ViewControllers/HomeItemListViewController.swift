//
//  HomeItemListViewController.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/21.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeItemListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ChildScrollableProtocol {
    
    // MARK: - Properties
    weak var tableView: UICollectionView!

    var childCanScroll = false
    var superCanScrollBlock: ((Bool) -> Void)?
    
    var homeItem = BehaviorRelay<HomeItem>(value:HomeItem())

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _initUI()
    }

    // MARK: - Initialize Appreaence
    private func _initUI() {
        _initTableView()
    }

    private func _initTableView() {
        let layout = DwFlowCollectionViewLayout()
        let tableView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.tableView = tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.backgroundColor = UIColor(hex: "#F9F9F9")
        tableView.collectionViewLayout = layout
        layout.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        tableView.register(UINib(nibName: "HomeItemListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeItemListCollectionViewCell")
    }

    // MARK: - CollectionView Delegate/DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeItem.value.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let homeSubItem = self.homeItem.value.items[indexPath.row]
        return collectionView.dequeueCell(ofType: HomeItemListCollectionViewCell.self, for: indexPath).then { cell in
            let cell = cell as! HomeItemListCollectionViewCell
            cell.setup(homeSubItem: homeSubItem)
        }
    }

    // MARK: - ScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !childCanScroll {
            scrollView.contentOffset.y = 0
        } else {
            if scrollView.contentOffset.y <= 0 {
                childCanScroll = false
                superCanScrollBlock?(true)
            }
        }
    }
}

extension HomeItemListViewController: DwFlowCollectionViewLayoutDelegate {
    func waterFallLayout(_ waterFallLayout: DwFlowCollectionViewLayout, heightForItemAtIndexPath indexPath: Int) -> CGFloat {
        
        let homeSubItem = self.homeItem.value.items[indexPath]
        let titleSize = homeSubItem.name.textSize(font: UIFont.systemFont(ofSize: 15.0), maxSize:CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(30.0)) )
        var height: CGFloat = 295.0
        height += CGFloat(Int(titleSize.width / ((DwScreen.width - 30)/2))) * 18.0
        return height
        
    }
}
