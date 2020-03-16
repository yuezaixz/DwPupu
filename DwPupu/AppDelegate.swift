//
//  AppDelegate.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/16.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    internal var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let indexViewController = PupuIndexViewController()
        let navigationController = UINavigationController(rootViewController: indexViewController)
        self.window!.rootViewController = navigationController
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()
        return true
    }


}

