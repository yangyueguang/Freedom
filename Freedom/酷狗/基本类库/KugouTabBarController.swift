//
//  KugouTabBarController.swift
//  Freedom
import UIKit
import XExtension
import AVFoundation
class KugouTabBarController: BaseTabBarViewController {
    let kugouMainVC = KugouMainViewController.storyVC("Kugou")
    override func viewDidLoad() {
        super.viewDidLoad()
        //创建RESideMenu对象(指定内容/左边/右边)
        let navi = KugouNavigationViewController(rootViewController: kugouMainVC)
        let sideViewController = RESideMenu(contentViewController: navi, leftMenuViewController: KugouSettingViewController(), rightMenuViewController: KugouRightSettingViewController())
        sideViewController?.backgroundImage = UIImage(named:"bj");
        //设置内容控制器的阴影颜色/半径/enable
        sideViewController?.contentViewShadowColor = .black
        sideViewController?.contentViewShadowRadius = 10;
        sideViewController?.contentViewShadowEnabled = true
        addChild(sideViewController!)
    }
}
