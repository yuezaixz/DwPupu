//
//  CategoryViewModel.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/22.
//  Copyright © 2020 davidandty. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CategoryViewModel {
    private let disposeBag = DisposeBag()


    // MARK: - Input
    var selectIndex: Int = 0 {
      didSet {
        if (selectIndex < categories.value.count) {
            selectedIndex.accept(selectIndex)
        }
      }
    }

    // MARK: - Output
    let selectedIndex = BehaviorRelay<Int>(value: 0)
    let title = BehaviorRelay<String>(value: "")
    let categories = BehaviorRelay<[Category]>(value: [])
    let linkUrlMap = BehaviorRelay<[String:String]>(value: [:])

    // MARK: - Init
    init() {
      bindOutput()
    }

    // MARK: - Methods
    func bindOutput() {
        Category.categorys().bind(to: categories).disposed(by: disposeBag)
        Category.homeSearchPlaceholder.bind(to: title).disposed(by: disposeBag)
        Banner.linkUrlMap.bind(to: linkUrlMap).disposed(by: disposeBag)
        
    }
}
