//
//  SegueConfig.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Foundation
import SwiftUI

class SegueConfig {
    static let shared = SegueConfig()
    
    var window: UIWindow!
    
    func getWindow() -> UIWindow? {
        guard let window = UIWindow.key else {
            return nil
        }
        
        return window
    }
    
    func controller() -> UIViewController? {
        guard let window = UIWindow.key else {
            return nil
        }
        
        guard let controller = window.rootViewController else {
            return nil
        }
        
        return controller
    }
    
    func present<T: View>(view: T,
                          style: UIModalPresentationStyle = .fullScreen,
                          animated: Bool = true,
                          isTopController: Bool = false) {
        var currentController: UIViewController?
        if isTopController {
            currentController = UIApplication.topViewController()
        } else {
            currentController = controller()
        }
        guard let current = currentController else {
            return
        }
        let controller = UIHostingController(rootView: view)
        controller.modalPresentationStyle = style
        current.present(controller,
                        animated: animated,
                        completion: nil)
    }
    
    func navigation<T: View>(view: T,
                             animation: Bool = true) {
        guard let current = controller() else {
            return
        }
        let controller = UIHostingController(rootView: view)
        controller.modalPresentationStyle = .fullScreen
        guard let split = current.children.first as? UISplitViewController else {
            return
        }
        guard let navigation = split.viewControllers.first as? UINavigationController else {
            return
        }
        navigation.pushViewController(controller, animated: animation)
    }
    
    func present<T: View>(main: T,
                          isSocket: Bool = true,
                          isReload: Bool = false,
                          animated: Bool = false,
                          completion: (() -> Void)? = nil) {
        guard let window = self.window else {
            return
        }
        
        if !isReload {
            guard let current = controller() else {
                return
            }
            current.dismiss(animated: animated,
                            completion: completion)
        }
        
        let controller = UIHostingController(rootView: main)
        controller.modalPresentationStyle = .fullScreen
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
    
    func dismiss(animated: Bool = true,
                 completion: (() -> Void)? = nil,
                 isTopController: Bool = false) {
        var currentController: UIViewController?
        if isTopController {
            currentController = UIApplication.topViewController()
        } else {
            currentController = controller()
        }
        guard let current = currentController else {
            return
        }
        current.dismiss(animated: animated, completion: completion)
    }
    
    func popViewController(animated: Bool = true,
                           completion: (() -> Void)? = nil) {
        guard let current = controller() else {
            return
        }

        guard let split = current.children.first as? UISplitViewController else {
            return
        }
        guard let navigation = split.viewControllers.first  as? UINavigationController else {
            return
        }
        navigation.popViewController(animated: animated)
    }
    
    func popToRootViewController(animated: Bool = true) {
        guard let current = controller() else {
            return
        }
        guard let split = current.children.first as? UISplitViewController else {
            return
        }
        guard let navigation = split.viewControllers.first  as? UINavigationController else {
            return
        }
        navigation.popToRootViewController(animated: animated)
    }
    
}
