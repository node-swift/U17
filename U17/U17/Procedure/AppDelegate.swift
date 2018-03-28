//
//  AppDelegate.swift
//  U17
//
//  Created by charles on 2017/9/29.
//  Copyright © 2017年 None. All rights reserved.
//

// UI工具包
import UIKit
// @see https://blog.csdn.net/xoxo_x/article/details/76390775
// 网络请求的开源库
import Alamofire
// 键盘监听
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // 延时加载reachability
    lazy var reachability: NetworkReachabilityManager? = {
        // 实时监测与http://app.u17.com连接状况
        return NetworkReachabilityManager(host: "http://app.u17.com")
    }()
    
    // 设置为竖屏显示
    var orientation: UIInterfaceOrientationMask = .portrait
    
    // 应用加载完成时
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        configBase()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = UTabBarController()
        window?.makeKeyAndVisible()
        //MARK: 修正齐刘海
//        UHairPowder.instance.spread()
        
        return true
    }
    
    // 基本配置
    func configBase() {
        // 开启键盘监听
        IQKeyboardManager.sharedManager().enable = true
        // 点击背景收起键盘
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        // 本地存储对象
        let defaults = UserDefaults.standard
        if defaults.value(forKey: String.sexTypeKey) == nil {
            // 设置性别类型为1（1：男性,2:女性？）
            defaults.set(1, forKey: String.sexTypeKey)
            // 保存数据
            defaults.synchronize()
        }

        reachability?.listener = { status in
            switch status {
            // 使用蜂窝数据时
            case .reachable(.wwan):
                // 通知显示
                UNoticeBar(config: UNoticeBarConfig(title: "主人,检测到您正在使用移动数据")).show(duration: 2)
            default: break
            }
        }
        // 开始监听
        reachability?.startListening()
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientation
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension UIApplication {
    class func changeOrientationTo(landscapeRight: Bool) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        // 横屏右转时
        if landscapeRight == true {
            
            // 代理的物理方向设置为右横屏
            delegate.orientation = .landscapeRight
            // 为window设置支持的方向
            UIApplication.shared.supportedInterfaceOrientations(for: delegate.window)
            // 设备设置为右横屏
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        } else {
            delegate.orientation = .portrait
            UIApplication.shared.supportedInterfaceOrientations(for: delegate.window)
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
}



