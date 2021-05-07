//
//  currentViewController.swift
//  BBQ
//
//  Created by ps on 07/05/2021.
//  Copyright © 2021 nbe. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func topMostViewController() -> UIViewController {
            
            if let navigation = self as? UINavigationController {
                return navigation.visibleViewController!.topMostViewController()
            }
            
            if let tab = self as? UITabBarController {
                if let selectedTab = tab.selectedViewController {
                    return selectedTab.topMostViewController()
                }
                return tab.topMostViewController()
            }
            
            if self.presentedViewController == nil {
                return self
            }
            
            if let navigation = self.presentedViewController as? UINavigationController {
                return navigation.visibleViewController!.topMostViewController()
            }
            
            if let tab = self.presentedViewController as? UITabBarController {
                
                if let selectedTab = tab.selectedViewController {
                    return selectedTab.topMostViewController()
                }
                
                return tab.topMostViewController()
            }
            
            return self.presentedViewController!.topMostViewController()
        }
}
