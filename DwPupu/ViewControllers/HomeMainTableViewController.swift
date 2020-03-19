//
//  HomeMainTableViewController.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/19.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit

class HomeMainTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Properties
    weak var tableView: UITableView!

    var childCanScroll = false
    var superCanScrollBlock: ((Bool) -> Void)?

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
        tableView.rowHeight = 50
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }

    // MARK: - TableView Delegate/DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "First:\(indexPath.row)"
        cell.selectionStyle = .none
        return cell
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
