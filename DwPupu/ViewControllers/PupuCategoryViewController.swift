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
    private var currentCategoryViewController: CategoryMainItemViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCategoryTableView()
        self.setupMainScrollView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        leftTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.top)
        self.currentCategoryViewController?.toggleAnimation(animation: true)
    }
    
    // MARK: - setup View
    
    private func setupCategoryTableView() {
        leftTableView.register(UINib.init(nibName: "CategoryNaviTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryNaviTableViewCell")
        viewModel.categories.bind(to: leftTableView.rx.items(cellIdentifier: "CategoryNaviTableViewCell")){ index, model, cell in
            guard let categoryCell = cell as? CategoryNaviTableViewCell else {return}
            categoryCell.update(with: model)
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
            
            self.viewModel.selectIndex = 0
            if let lastVC = lastVC {
                lastVC.view.snp.makeConstraints { make in
                    make.bottom.equalToSuperview()
                }
            }
        }).disposed(by: disposeBag)
        
        let selectedIndex = self.viewModel.selectedIndex.skip(1).share(replay: 1)
        
        selectedIndex
            .map{ CGPoint(x: 0.0, y:self.leftTableView.bounds.height*CGFloat($0)) }
            .asDriver(onErrorJustReturn: CGPoint(x: 0, y: 0))
            .drive(containerScrollView.rx.contentOffset).disposed(by: disposeBag)
        selectedIndex.subscribeOn(MainScheduler.instance).subscribe(onNext: {[weak self] index in
            guard let self = self, index < self.categoryViewControllers.count  else { return }
                if let currentCategoryViewController = self.currentCategoryViewController {
                    currentCategoryViewController.toggleAnimation(animation: false)
                }
                self.categoryViewControllers[index].toggleAnimation(animation: true)
                self.currentCategoryViewController = self.categoryViewControllers[index]
            }).disposed(by: disposeBag)
            
        
    }

}

extension PupuCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectIndex = indexPath.row
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
}
