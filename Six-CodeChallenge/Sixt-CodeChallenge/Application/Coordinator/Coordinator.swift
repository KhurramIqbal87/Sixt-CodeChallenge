//
//  Coordinator.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 31/08/2022.
//

import Foundation
import UIKit
protocol Coordinator: AnyObject{
    
    func start()
}
// To keep the refernce of parent and child coordinator we use ParentCoordinator so we can also update parent at times coordinator is supposed to deinit and can take possible measures
protocol ParentCoordinator: Coordinator{
    var parentCoordinator: Coordinator?{get}
    var childCoordinators: [Coordinator]?{get}
    func didFinishChildCoordinator(coordintor: Coordinator)
}
