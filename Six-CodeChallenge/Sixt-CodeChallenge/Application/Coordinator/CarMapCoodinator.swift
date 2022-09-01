//
//  CarMapCoodinator.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 31/08/2022.
//

import Foundation
import UIKit

final class CarMapCoodinator: ParentCoordinator{
    var childCoordinators: [Coordinator]?
    
    func didFinishChildCoordinator(coordintor: Coordinator) {
        self.childCoordinators?.removeAll(where: { coordinator in
            return coordinator === coordintor
        })
    }
    
    var parentCoordinator: Coordinator?
    private let container : MapContainer = MapContainer.init()
    private var navigationController: UINavigationController
    
    init(parentCoordinator: ParentCoordinator, navController: UINavigationController){
        self.parentCoordinator = parentCoordinator
        self.navigationController = navController
    }
    
    // in start func we make sure we inject all dependencies needed for viewController, viewModel to start.
    func start() {
       
        let viewController = self.container.createMapViewController()
        self.navigationController.setViewControllers([viewController], animated: true)
    }
    deinit{
        if let coordinator = self.parentCoordinator as? ParentCoordinator{
            
            coordinator.didFinishChildCoordinator(coordintor: self)
        }
    }
    
}
