//
//  AppCoordinator.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 31/08/2022.
//

import Foundation
import Foundation
import UIKit
// App Coordinator is the Starting Point of an application
final class AppCoordinator: ParentCoordinator{
    var childCoordinators: [Coordinator]?
    
    var parentCoordinator: Coordinator?
    private var window: UIWindow
    init(window: UIWindow){
        self.window = window
    }
    
    func didFinishChildCoordinator(coordintor: Coordinator) {
        self.childCoordinators?.removeAll(where: { coordinator in
            return coordinator === coordintor
        })
    }
   
    func start() {
        
        let navController = UINavigationController.init()
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
        let tabBarCoordinator = TabBarCoordinator.init(parentCoordinator: self, navigationController: navController)
        self.childCoordinators?.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
    
}
