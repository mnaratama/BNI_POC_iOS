//
//  AppDelegate.swift
//  BNIMobile
//
//  Created by Greeshma Arunkumar on 03/03/23.
//

import UIKit
import AKNetworking

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Configure the AKNetworkingSession
        DataSourceManager.baseURLString = "https://otp-mavipoc-otp.apps.mavipoc-pb.duh8.p1.openshiftapps.com"
        DataSourceManager.localMode = false
        
        //Configure rootview based on Customer Registration Status
        chooseRootViewController()
        print("test")   
        return true
    }
    
    func chooseRootViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        var rootVC: UIViewController?
        
        guard let viewController = UIStoryboard(name: StoryboardName.main, bundle: nil).instantiateViewController(withIdentifier: ViewControllerName.rootNavigationVC) as? UINavigationController else {
            fatalError("Failed to load Main from CustomerRegView file")
        }
        rootVC = viewController
        
        let hasCustomerRegistred = UserDefaults.standard.bool(forKey: "hasCustomerRegistered")
        
        if hasCustomerRegistred {
            guard let preLoginVC = UIStoryboard(name: StoryboardName.preLogin, bundle: nil).instantiateViewController(withIdentifier: ViewControllerName.preLoginVC) as? PreLoginViewController else {
                fatalError("Failed to load PreLogin from PreLoginViewController file")
            }
            rootVC = preLoginVC
        }
        
        guard let vc = rootVC else {
            fatalError("Failed to load Main from CustomerRegView file")
        }
        
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
}

