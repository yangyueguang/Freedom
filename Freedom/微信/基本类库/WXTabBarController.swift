//
//  WXTabBarController.swift
//  Freedom

import UIKit
import SnapKit
//import XCarryOn
//import XExtension
final class WXTabBarController: BaseTabBarViewController {
    static var shared: WXTabBarController!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        WXTabBarController.shared = self
        let barItem = UITabBarItem.appearance()
        barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.grayx,NSAttributedString.Key.font : UIFont.small.bold], for: .normal)
        barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.greenx,NSAttributedString.Key.font : UIFont.small.bold], for: .selected)
        tabBar.barTintColor = .white
        tabBar.tintColor = .green
        if FirstRun.shared.wechat {
            FirstRun.shared.wechat = false
            XNetKit.kit.downloadDefaultExpression()
        }
    }
    
}
