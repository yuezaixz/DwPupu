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
    
    @IBOutlet weak var containerView: UIView!
    private var containerScrollView:UIScrollView!
    
    private var categoryViewControllers:[CategoryMainItemViewController] = []
    private var currentCategoryViewController: CategoryMainItemViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCategoryTableView()
        self.setupMainScrollView()
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
    
    private func setupMainScrollView() {
        let containerScrollView = UIScrollView()
        self.containerScrollView = containerScrollView
        containerScrollView.isScrollEnabled = false
        self.containerView.addSubview(containerScrollView)
        
        containerScrollView.snp.makeConstraints {[weak self]  (make) in
            guard let self = self else { return }
            make.trailing.bottom.top.equalTo(0)
            make.left.equalTo(self.leftTableView.snp.right)
        }
        
        self.viewModel.categories.subscribe(onNext: {[weak self] (categories) in
            guard let self = self else { return }
            containerScrollView.contentSize = CGSize(width: DwScreen.width-self.leftTableView.bounds.width, height: self.leftTableView.bounds.height*CGFloat(categories.count))
            

            var lastVC:UIViewController?
            categories.forEach { [weak self] category in
                guard let self = self else { return }
                let otherVC = CategoryMainItemViewController()
                otherVC.category.accept(category)
                self.addChild(otherVC)
                self.categoryViewControllers.append(otherVC)
                containerScrollView.addSubview(otherVC.view)
                otherVC.view.snp.makeConstraints { (make) in
                    make.top.equalTo(lastVC?.view.snp.bottom ?? containerScrollView.snp.top)
                    make.left.right.equalTo(0)
                    make.width.equalTo(containerScrollView.snp.width)
                    make.height.equalTo(self.leftTableView.snp.height)
                }
                
                lastVC = otherVC
            }
            if let lastVC = lastVC {
                lastVC.view.snp.makeConstraints { make in
                    make.bottom.equalToSuperview()
                }
            }
        }).disposed(by: disposeBag)
    }

}

extension PupuCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row < viewModel.categories.value.count) {
            print(viewModel.categories.value[indexPath.row].name)
            containerScrollView.setContentOffset(CGPoint(x: 0.0, y:self.leftTableView.bounds.height*CGFloat(indexPath.row)), animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
}
