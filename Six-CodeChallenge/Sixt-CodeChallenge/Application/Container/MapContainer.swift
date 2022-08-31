//
//  MapContainer.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 31/08/2022.
//

import Foundation
import UIKit
final class MapContainer{
    func createMapViewController()->UIViewController{
        
        let viewController = MapViewController<MapViewModel>.init(viewModel: self.createMapViewModel(), mapViewModel: self.createCustomMapViewModel())
        return viewController
    }
    
     func createMapViewModel()-> MapViewModel{
         
         let viewModel = MapViewModel.init(repo: self.createDriverListRepository())
         
         return viewModel
    }
    func createCustomMapViewModel()->CustomMapViewModel{
        let repo = ImageRepository.init(clientManager: ApiClient.sharedInstance)
        let viewModel = CustomMapViewModel.init(repo: repo)
        return viewModel
    }
    
    func createDriverListRepository()->DriverListRepositoryType{
        let repository = DriverListRepository.init(networkManager: ApiClient.sharedInstance)
        return repository
    }
}
