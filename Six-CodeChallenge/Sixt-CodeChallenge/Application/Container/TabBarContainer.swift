//
//  TabBarContainer.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 31/08/2022.
//


import Foundation
import UIKit
final class TabBarContainer{
    func createTabBar()->UITabBarController{
       
        let tabBarController =  TabBarViewController.init(viewModel: self.createViewModel())
        return tabBarController
    }
    func createViewModel()->TabBarViewModel{
        let viewModel = TabBarViewModel.init()
        return viewModel
    }
    
    func createTabBarVC(coordinator: ParentCoordinator, childCoordinators: inout [Coordinator])->[UIViewController]{
        
        let carListNVC = UINavigationController()
        let carMapNVC = UINavigationController()
        
        let carListCoordinator = CarListCoordinator.init(parentCoordinator: coordinator, navigationController: carListNVC)
        
        let carMapCoordinator = CarMapCoodinator.init(parentCoordinator: coordinator, navController: carMapNVC )
     
        carMapNVC.tabBarItem = UITabBarItem.init(title: "Map", image: UIImage.init(named: "MapUnselectedIcon"), selectedImage: nil)
        
        carListNVC.tabBarItem = UITabBarItem.init(title: "CarList", image: UIImage.init(named: "DriverIcon"), selectedImage: nil)
        
        carMapCoordinator.start()
        carListCoordinator.start()
        
        childCoordinators.append(carMapCoordinator)
        childCoordinators.append(carListCoordinator)
        
        return [carListNVC, carMapNVC]
        
    }
}
