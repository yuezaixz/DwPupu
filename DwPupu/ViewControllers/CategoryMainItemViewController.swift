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

class CategoryMainItemViewController: UIViewController {
    
    let category = BehaviorRelay<Category>(value:Category())

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
