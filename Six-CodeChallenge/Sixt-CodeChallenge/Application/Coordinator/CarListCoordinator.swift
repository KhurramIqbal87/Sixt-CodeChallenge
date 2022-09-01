//
//  CarListCoordinator.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 31/08/2022.
//

import Foundation
import UIKit

final class CarListCoordinator: NSObject, ParentCoordinator{
    var childCoordinators: [Coordinator]?
    
    var parentCoordinator: Coordinator?
    
    private let container: CarListContainer = CarListContainer.init()
    var navController: UINavigationController
    
    init(parentCoordinator: Coordinator, navigationController: UINavigationController ){
        self.parentCoordinator = parentCoordinator
        self.navController = navigationController
   }
// in start func we make sure we inject all dependencies needed for viewController, viewModel to start.
    func start() {
        
        let viewController = self.container.createCarListViewController()
        
        self.navController.setViewControllers([viewController], animated: true)
            
    }
    
    func didFinishChildCoordinator( coordintor: Coordinator) {
        guard var childCoordinator = self.childCoordinators else{return}
        
        childCoordinator.removeAll { coordinator in
            return coordinator === coordintor
        }
    }
    
    deinit{
        if let coordinator = self.parentCoordinator as? ParentCoordinator{
            
            coordinator.didFinishChildCoordinator(coordintor: self)
        }
    }
}
