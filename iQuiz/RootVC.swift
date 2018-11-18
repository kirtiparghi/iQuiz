//
//  RootVC.swift
//  iQuiz
//
//  Created by MacStudent on 2017-10-13.
//  Copyright © 2017 MacStudent. All rights reserved.
//

import UIKit

class RootVC: UIViewController {

    fileprivate var rootViewController: UIViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSplashViewController()
    }
    
    /// Does not transition to any other UIViewControllers, SplashViewController only
    func showSplashViewControllerNoPing() {
        
        if rootViewController is SplashViewController {
            return
        }
        
        rootViewController?.willMove(toParentViewController: nil)
        rootViewController?.removeFromParentViewController()
        rootViewController?.view.removeFromSuperview()
        rootViewController?.didMove(toParentViewController: nil)
        
        let splashViewController = SplashViewController(tileViewFileName: "LaunchImage")
        rootViewController = splashViewController
        splashViewController.pulsing = true
        
        splashViewController.willMove(toParentViewController: self)
        addChildViewController(splashViewController)
        view.addSubview(splashViewController.view)
        splashViewController.didMove(toParentViewController: self)
    }
    
    /// Simulates an API handshake success and transitions to MapViewController
    func showSplashViewController() {
        showSplashViewControllerNoPing()
        
        delay(3.00) {
            self.showMenuNavigationViewController()
        }
    }
    
    /// Displays the MapViewController
    func showMenuNavigationViewController() {
        guard !(rootViewController is RootVC) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let defaults = UserDefaults.standard
        var nav: UINavigationController! = UINavigationController()
        var str = defaults.value(forKey: "currentName") as? String
        if str == nil {
            nav =  storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController
        }
        else {
            nav =  storyboard.instantiateViewController(withIdentifier: "DashboardNavigationController") as! UINavigationController
        }
        
        nav.willMove(toParentViewController: self)
        addChildViewController(nav)
        
        if let rootViewController = self.rootViewController {
            self.rootViewController = nav
            rootViewController.willMove(toParentViewController: nil)
            
            transition(from: rootViewController, to: nav, duration: 0.55, options: [.transitionCrossDissolve, .curveEaseOut], animations: { () -> Void in
                
            }, completion: { _ in
                nav.didMove(toParentViewController: self)
                rootViewController.removeFromParentViewController()
                rootViewController.didMove(toParentViewController: nil)
            })
        } else {
            rootViewController = nav
            view.addSubview(nav.view)
            nav.didMove(toParentViewController: self)
        }
    }
    
    
    override var prefersStatusBarHidden : Bool {
        switch rootViewController  {
        case is SplashViewController:
            return true
        case is RootVC:
            return false
        default:
            return false
        }
}

}
