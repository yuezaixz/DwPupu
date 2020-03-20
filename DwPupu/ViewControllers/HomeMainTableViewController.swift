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

class HomeMainTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
        
        tableView.register(UINib(nibName: "HomeShopRecommendBlickTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeShopRecommendBlickTableViewCell")
    }

    // MARK: - TableView Delegate/DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeItems.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeItem = self.homeItems.value[indexPath.row]
        return tableView.dequeueCell(ofType: HomeShopRecommendBlickTableViewCell.self).then { cell in
            guard let cell = cell as? HomeShopRecommendBlickTableViewCell else { return }
            cell.setup(homeItem: homeItem)
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
