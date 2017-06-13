//
//  AppController.swift
//  InThree
//
//  Created by Patrick O'Leary on 4/26/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit
import FirebaseAuth

class AppController: UIViewController {
    
    var containerView: UIView!
    var actingVC: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView = UIView(frame: view.frame)
        view = containerView
        addNotifcationObservers()
        loadInitialViewController()
    }
}

//MARK: - Notification Observers

extension AppController {
    func addNotifcationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .closeLoginVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .closeDashboardVC, object: nil)
    }
}

extension AppController {
    func loadInitialViewController() {
        
        if (FIRAuth.auth()?.currentUser?.uid) == nil { //If there is no current user, go to the Login Screen
            let loginNavC = LoginNavC()
            self.actingVC = loginNavC
            self.add(viewController: self.actingVC, animated: true)
        } else {
            let dashboardNavC = DashboardNavC()
            self.actingVC = dashboardNavC
            self.add(viewController: self.actingVC, animated: true)
        }
    }
}

//MARK: Switch VC Functions

extension AppController {
    
    func add(viewController: UIViewController, animated: Bool = false) {
        self.addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        containerView.alpha = 0.0
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
        
        guard animated else { containerView.alpha = 1.0; return }
        
        UIView.transition(with: containerView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.containerView.alpha = 1.0
        }) { _ in }
    }
    
    func switchViewController(with notification: Notification) {
        switch notification.name {
        case Notification.Name.closeLoginVC:
            switchToViewController(with: DashboardNavC())
        case Notification.Name.closeDashboardVC:
            switchToViewController(with: LoginNavC())
        default:
            fatalError("\(#function) - Unable to match notficiation name.")
        }
        
    }
    
    private func switchToViewController(with vc: UIViewController) {
        let existingVC = actingVC
        existingVC?.willMove(toParentViewController: nil)
        actingVC = vc
        add(viewController: actingVC)
        actingVC.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.8, animations: {
            self.actingVC.view.alpha = 1.0
            existingVC?.view.alpha = 0.0
        }) {
            success in
            existingVC?.view.removeFromSuperview()
            existingVC?.removeFromParentViewController()
            self.actingVC.didMove(toParentViewController: self)
        }
        
    }
    
}



