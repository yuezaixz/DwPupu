//
//  HomeMainTableViewController.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/19.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit
import Then
import RxSwift
import RxCocoa

class HomeMainTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChildScrollableProtocol {
    // MARK: - Properties
    weak var tableView: UITableView!

    var childCanScroll = false
    var superCanScrollBlock: ((Bool) -> Void)?
    
    var homeItems = BehaviorRelay<[HomeItem]>(value: [])
    
    var homeData:Binder<[HomeItem]>{
        return Binder(self) { viewController, homeItems in
//            guard let homeItem = homeItem else { return }
            viewController.homeItems.accept(homeItems)
        }
    }

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
        let tableView = UITableView()
        self.tableView = tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame:CGRect(x: 0, y: 0, width: DwScreen.width, height: 80))
        
        tableView.register(UINib(nibName: "HomeShopRecommendBlickTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeShopRecommendBlickTableViewCell")
        tableView.register(UINib(nibName: "HomeShopOtherBlockTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeShopOtherBlockTableViewCell")
    }

    // MARK: - TableView Delegate/DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeItems.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let homeItem = self.homeItems.value[indexPath.row]
        if (homeItem.name == "掌柜推荐") {
            return HomeShopRecommendBlickTableViewCell.cellHeight
        } else {
            return HomeShopOtherBlockTableViewCell.cellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let homeItem = self.homeItems.value[indexPath.row]
        if (homeItem.name == "掌柜推荐") {
            return HomeShopRecommendBlickTableViewCell.cellHeight
        } else {
            return HomeShopOtherBlockTableViewCell.cellHeight
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeItem = self.homeItems.value[indexPath.row]
        if (homeItem.name == "掌柜推荐") {
            return tableView.dequeueCell(ofType: HomeShopRecommendBlickTableViewCell.self).then { cell in
                cell.setup(homeItem: homeItem)
            }
        } else {
            return tableView.dequeueCell(ofType: HomeShopOtherBlockTableViewCell.self).then { cell in
                cell.setup(homeItem: homeItem)
            }
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
