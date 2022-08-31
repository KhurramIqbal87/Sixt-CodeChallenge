//
//  TabBarCoordinator.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 31/08/2022.
//

import Foundation
import UIKit

// This application is supposed to be tab bar we have two tab bars one for showing drivers on map with respect to our current location and other showing all driver in a list.
final class TabBarCoordinator: ParentCoordinator{
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator]?
    let container: TabBarContainer = TabBarContainer.init()
    
    private var naviagationController: UINavigationController
    private let tabBar: UITabBarController
    
    init(parentCoordinator: Coordinator, navigationController: UINavigationController){
        
        self.naviagationController = navigationController
        
        self.parentCoordinator = parentCoordinator
        self.tabBar = self.container.createTabBar()
    }
    func start() {
        
        self.naviagationController.setViewControllers([self.tabBar], animated: true)
        var childCoordinator = self.childCoordinators ?? []
        let viewControllers = self.container.createTabBarVC(coordinator: self, childCoordinators: &(childCoordinator))
        
        self.childCoordinators = childCoordinator
        
        self.tabBar.setViewControllers(viewControllers, animated: true)
        
    }
    func didFinishChildCoordinator(coordintor: Coordinator) {
        self.childCoordinators?.removeAll(where: { coordinator in
            return coordintor === coordintor
        })
    }
    
 // Here we create two more coordinators and put set their navigation controller to tab bar viewControllers
   
    deinit{
        if let coordinator = self.parentCoordinator as? ParentCoordinator{
            
            coordinator.didFinishChildCoordinator(coordintor: self)
        }
    }
    
}
