//
//  AppDelegate.swift
//  Homepwner
//
//  Created by iel-mac on 2017/7/3.
//  Copyright © 2017年 iel-mac. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let itemStore = ItemStore()

    //APP第一次启动的时候会调用
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print(#function)
        //创造ItemStore
        //let itemStore = ItemStore()
        //创造ImageStore
        let imageStore = ImageStore()
        
        //as 向上转型  as！向下转型  还有一个 as?
        //let itemController = window!.rootViewController as! ItemsViewController
        
        //学习 NavigationController
        //这里的根view应该变成navigationViewCotroller了
        let navController = window!.rootViewController as! UINavigationController
        let itemController = navController.topViewController as! ItemsViewController
        
        itemController.itemStore = itemStore
        itemController.imageStore = imageStore
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print(#function)
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    
    
    /*
     这是用户按下home键的时候回调的方法，在这个使用可以保存数据
     */
    func applicationDidEnterBackground(_ application: UIApplication) {
        print(#function)
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let success = itemStore.saveChanges()
        if (success){
            print("all items saved")
        }else{
            print("could not save any of the item")
        }
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print(#function)
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print(#function)
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print(#function)
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

