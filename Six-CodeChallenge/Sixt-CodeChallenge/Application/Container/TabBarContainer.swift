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
        
        let driverListNVC = UINavigationController()
        let driverMapNVC = UINavigationController()
        
        let driverListCoordinator = DriverListCoordinator.init(parentCoordinator: coordinator, navigationController: driverListNVC)
        
        let driverMapCoordinator = DriverMapCoodinator.init(parentCoordinator: coordinator, navController: driverMapNVC )
     
        driverMapNVC.tabBarItem = UITabBarItem.init(title: "Map", image: UIImage.init(named: "MapUnselectedIcon"), selectedImage: nil)
        
        driverListNVC.tabBarItem = UITabBarItem.init(title: "DriverList", image: UIImage.init(named: "DriverIcon"), selectedImage: nil)
        
        driverMapCoordinator.start()
        driverListCoordinator.start()
        
        childCoordinators.append(driverMapCoordinator)
        childCoordinators.append(driverListCoordinator)
        
        return [driverListNVC, driverMapNVC]
        
    }
}
