//
//  DriverListViewModel.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 31/08/2022.
//

import Foundation
import Combine
import CoreLocation
/// DriverListViewModel updates its data on viewdidload callback and it also refresh data on refresh callback
@objcMembers
final class DriverListViewModel: NSObject,  DriverListViewModelType {
   
    private var repository: DriverListRepositoryType
    private var cancelables: [AnyCancellable]  = []
    
    var itemsPublisher: Published<[DriverListItemViewModelType]>.Publisher{$items}
    
    var loadingPublisher: Published<Bool>.Publisher{$isLoading}
    
    var errorPublisher: Published<String>.Publisher {$showError}
    
 
    
    @Published private var items: [DriverListItemViewModelType] = []
    @Published private var isLoading: Bool = false
    @Published private var showError: String = ""
   
    init(repository: DriverListRepositoryType) {
        self.repository = repository
    }
    private override init(){
        self.repository = DriverListRepository.init()
    }
    func viewDidLoad() {
        self.getDriverList()
    }
    func refresh(){
        self.getDriverList()
    }
    
    func getTitle() -> String {
        return "Driver List"
    }
    
    private func getDriverList(){
   
        self.isLoading = true
        self.repository.getDriverList() { [weak self] drivers, error in
            guard let self = self else{return}
            
            self.isLoading = false
            
            if let error = error{
                self.showError = error
                return
            }
            if let drivers = drivers{
                self.convertModelToViewModels(drivers: drivers)
            }
        }
    }
    private func convertModelToViewModels(drivers: driverList){
        
        self.items =  drivers.compactMap { driver in
            return DriverListItemViewModel.init(model:driver)
        }
    }
}
