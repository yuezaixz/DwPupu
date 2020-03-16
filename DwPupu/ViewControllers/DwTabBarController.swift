//
//  DwTabBarController.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/16.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit

class DwTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBarItem()
    }
    
    func setupTabBarItem() {
        
        let indexViewController = PupuIndexViewController()
        let navigationController = UINavigationController(rootViewController: indexViewController)
        
        let pupuCategoryViewController = PupuCategoryViewController()
        let pupuShopViewController = PupuShopCarViewController()
        let pupuMyViewController = PupuMyViewController()
        
        indexViewController.tabBarItem.title = "首页"
        indexViewController.tabBarItem.image = UIImage(named: "icon_home_normal")
        indexViewController.tabBarItem.selectedImage = UIImage(named: "icon_home_selected")
        pupuCategoryViewController.tabBarItem.title = "分类"
        pupuCategoryViewController.tabBarItem.image = UIImage(named: "category_normal")
        pupuCategoryViewController.tabBarItem.selectedImage = UIImage(named: "category_selected")
        pupuShopViewController.tabBarItem.title = "购物车"
        pupuShopViewController.tabBarItem.image = UIImage(named: "shoppingcart_normal")
        pupuShopViewController.tabBarItem.selectedImage = UIImage(named: "shoppingcart_selected")
        pupuMyViewController.tabBarItem.title = "我的"
        pupuMyViewController.tabBarItem.image = UIImage(named: "mine_normal")
        pupuMyViewController.tabBarItem.selectedImage = UIImage(named: "mine_selected")
        
        self.viewControllers = [navigationController, pupuCategoryViewController, pupuShopViewController, pupuMyViewController]
        
        let tabBar = DwTabBar(frame: self.tabBar.frame)
        tabBar.tintColor = UIColor(red: 0.0, green: 180.0/255.0, blue: 82.0/255.0, alpha: 1.0)
        
        self.setValue(tabBar, forKeyPath: "tabBar")
        
        // 一个坑：因为自定义了tabBar,需要重新设置，但是如果只设置成0是无效的，估计内部又判断值没变就不执行逻辑了
        self.selectedIndex = 1
        self.selectedIndex = 0
    }
}
