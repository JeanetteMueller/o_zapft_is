//
//  Coordinator.swift
//  o_zapft_is
//
//  Created by Jeanette Müller on 14.12.23.
//

import UIKit

protocol Coordinator: AnyObject{
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    
    func popViewController(animated: Bool, useCustomAnimation: Bool, transitionType: CATransitionType)

}

extension Coordinator {
    /**
     Pops the top view controller from the navigation stack and updates the display.
     
     - Parameters:
     - animated: Set this value to true to animate the transition.
     - useCustomAnimation: Set to true if you want a transition from top to bottom.
     */
    func popViewController(animated: Bool, useCustomAnimation: Bool = false, transitionType: CATransitionType = .push) {
        
        navigationController.popViewController(animated: animated)
    }
    
    /**
     Pops view controllers until the specified view controller is at the top of the navigation stack.
     - Parameters:
     - ofClass: The view controller that you want to be at the top of the stack. This view controller must currently be on the navigation stack.
     - animated: Set this value to true to animate the transition.
     */
    func popToViewController(vc: UIViewController, animated: Bool = true) {
        navigationController.popToViewController(vc, animated: animated)
    }
    
    /**
     Pops view controllers until the specified view controller is at the top of the navigation stack.
     
     - Parameters:
     -  viewController: The view controller that you want to be at the top of the stack. This view controller must currently be on the navigation stack.
     - animated: Set the value to true to animate the transition.
     - useCustomAnimation: Set to true if you want a transition from top to the bottom.
     */
    func popViewController(to viewController: UIViewController, animated: Bool, useCustomAnimation: Bool, transitionType: CATransitionType = .push) {
        
        
        navigationController.popToViewController(viewController, animated: animated)
        
    }
}
