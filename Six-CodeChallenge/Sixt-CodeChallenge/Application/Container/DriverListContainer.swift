//
//  DriverListContainer.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 31/08/2022.
//

import Foundation
import UIKit

final class DriverListContainer{
    
    func createDriverListViewController()->UIViewController{
     
        let viewController = DriverListViewController<DriverListViewModel>.init(viewModel: self.createDriverListViewModel())
        return viewController
    }
    
     func createDriverListViewModel()-> DriverListViewModel{
         let driverListViewModel = DriverListViewModel.init(repository: self.createDriverListRepository())
         
         return driverListViewModel
    }
    
    func createDriverListRepository()->DriverListRepositoryType{
        let repository = DriverListRepository.init(networkManager: ApiClient.sharedInstance)
        return repository
    }
}
