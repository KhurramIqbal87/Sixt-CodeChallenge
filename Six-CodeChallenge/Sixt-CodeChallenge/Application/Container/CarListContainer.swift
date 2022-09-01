//
//  CarListContainer.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 31/08/2022.
//

import Foundation
import UIKit

final class CarListContainer{
    
    func createCarListViewController()->UIViewController{
     
        let viewController = CarListViewController<CarListViewModel>.init(viewModel: self.createCarListViewModel())
        return viewController
    }
    
     func createCarListViewModel()-> CarListViewModel{
        
         let carListViewModel = CarListViewModel.init(repository: self.createCarListRepository())
         
         return carListViewModel
    }
    
    func createCarListRepository()->CarListRepositoryType{
        
        let repository = CarListRepository.init(networkManager: ApiClient.sharedInstance)
        return repository
    }
}
