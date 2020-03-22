//
//  PupuCategoryViewController.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/16.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PupuCategoryViewController: UIViewController {

    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var leftTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = CategoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCategoryTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        leftTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.top)
    }
    
    // MARK: - setup View
    
    private func setupCategoryTableView() {
        leftTableView.register(UINib.init(nibName: "CategoryNaviTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryNaviTableViewCell")
        viewModel.categories.bind(to: leftTableView.rx.items(cellIdentifier: "CategoryNaviTableViewCell")){ index, model, cell in
            guard let categoryCell = cell as? CategoryNaviTableViewCell else {return}
            categoryCell.nameLabel.text = model.name
        }.disposed(by: disposeBag)
    }

}

extension PupuCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row < viewModel.categories.value.count) {
            print(viewModel.categories.value[indexPath.row].name)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
}
