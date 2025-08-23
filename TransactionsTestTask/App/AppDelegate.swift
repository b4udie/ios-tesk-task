//
//  AppDelegate.swift
//  TransactionsTestTask
//
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        let event = AppLifecycleEvent(action: "willEnterForeground")
        ServicesAssembler.analyticsService().trackEvent(event)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        let event = AppLifecycleEvent(action: "willResignActive")
        ServicesAssembler.analyticsService().trackEvent(event)
    }
}
