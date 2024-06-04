//
//  AppDelegate.swift
//  SwiftCart
//
//  Created by Mac on 30/05/2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Create a UIWindow instance
        window = UIWindow(frame: UIScreen.main.bounds)

        // Load the Login view controller from the Nib file
        let sginUPViewController = Login(nibName: "Login", bundle: nil)
        
        // Create a navigation controller with Login as the root view controller
        let navigationController = UINavigationController(rootViewController: sginUPViewController)
        
        // Set the root view controller of the window to be the navigation controller
        window?.rootViewController = navigationController

        // Make the window visible
        window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
        print("Window: \(window)")
        print("Root ViewController: \(window?.rootViewController)")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

