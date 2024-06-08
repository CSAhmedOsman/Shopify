//
//  AppCoordinator.swift
//  SwiftCart
//
//  Created by Anas Salah on 07/06/2024.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let vc = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        
        let mainViewController = Login(nibName: "Login", bundle: Bundle.main)
        mainViewController.coordinator = self
        
        navigationController.pushViewController(mainViewController, animated: false)
    }
    
    func gotoLogin(pushToStack: Bool) {
        if let loginViewController = navigationController.viewControllers.last(where: { $0 is Login }), !pushToStack {
            navigationController.popToViewController(loginViewController, animated: true)
        } else {
            let login = Login(nibName: K.Auth.loginNibName, bundle: nil)
            login.coordinator = self
            navigationController.pushViewController(login, animated: true)
        }
    }
    
    func gotoSignUp(pushToStack: Bool) {
        
        if let sginUpViewController = navigationController.viewControllers.last(where: { $0 is SginUp }), !pushToStack {
            navigationController.popToViewController(sginUpViewController, animated: true)
        } else {
            let sginUp = SginUp(nibName: K.Auth.sginUpNibName, bundle: nil)
            sginUp.coordinator = self
            navigationController.pushViewController(sginUp, animated: true)
        }
    }
    
    
    func gotoHome() {
        
        let storyboard = UIStoryboard(name: K.Home.homeStoryboardName, bundle: Bundle.main)
        let homeVc = storyboard.instantiateViewController(withIdentifier: K.Home.homeViewName) as! HomeViewController
        let categoryVc = storyboard.instantiateViewController(withIdentifier: K.Home.categoryViewName) as! CategoryViewController
        homeVc.coordinator = self
        categoryVc.coordinator = self
        
        homeVc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
           categoryVc.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "list.bullet"), tag: 1)
           
           let tabBar = UITabBarController()
           tabBar.viewControllers = [homeVc, categoryVc]
        tabBar.tabBar.backgroundColor = .white
        
        navigationController.pushViewController(tabBar, animated: true)
    }
    
    
    
    func finish() {
        navigationController.popViewController(animated: true)
    }
}