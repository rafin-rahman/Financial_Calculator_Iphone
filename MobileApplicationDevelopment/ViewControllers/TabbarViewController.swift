//
//  TabbarViewController.swift
//  MobileApplicationDevelopment
//
//  Created by Rafin Rahman on 26/02/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.unselectedItemTintColor = UIColor.white
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        viewController.viewDidLoad()
        
    }

}
