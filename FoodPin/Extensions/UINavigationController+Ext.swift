//
//  UINavigationController+Ext.swift
//  FoodPin
//
//  Created by leizhangjie on 2021/10/8.
//

import Foundation
import UIKit

extension UINavigationController {
  override open var childForStatusBarStyle: UIViewController? {
    return self.topViewController
  }

  override open var childForStatusBarHidden: UIViewController? {
    return self.topViewController
  }
}
