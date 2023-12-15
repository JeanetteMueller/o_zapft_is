//
//  RootCoordinator.swift
//  o_zapft_is
//
//  Created by Jeanette Müller on 14.12.23.
//

import UIKit

class RootCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        
    }
    
    
    
    func start() {
        let vc = RootViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showBeerList() {
        let vc = BeerListVC.instantiate()
        vc.coordinator = self
        vc.beers = StorageManager.shared.getAllBeer()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showBeer(_ beertype: BeerType) {
        
        let vc = BeerDetailVC.instantiate()
        vc.coordinator = self
        vc.beer = beertype
        
        navigationController.pushViewController(vc, animated: true)
    }
}
