//
//  CarListViewModel.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 31/08/2022.
//

import Foundation
import Combine
import CoreLocation
/// CarListViewModel updates its data on viewdidload callback and it also refresh data on refresh callback

final class CarListViewModel: NSObject,  CarListViewModelType {
   
    private var repository: CarListRepositoryType
    private var cancelables: [AnyCancellable]  = []
    
    var itemsPublisher: Published<[CarListItemViewModelType]>.Publisher{$items}
    
    var loadingPublisher: Published<Bool>.Publisher{$isLoading}
    
    var errorPublisher: Published<String>.Publisher {$showError}
    
 
    
    @Published private var items: [CarListItemViewModelType] = []
    @Published private var isLoading: Bool = false
    @Published private var showError: String = ""
   
    //MARK: - Initializer
    init(repository: CarListRepositoryType) {
        self.repository = repository
    }
    //MARK: - Implementations
    
    func viewDidLoad() {
        self.getCarList()
    }
    func refresh(){
        self.getCarList()
    }
    
    func getTitle() -> String {
        return "Car List"
    }
}

extension CarListViewModel{
    
    //MARK: - Private Functions
    
    private func getCarList(){
   
        self.isLoading = true
        self.repository.getCarList() { [weak self] cars, error in
            guard let self = self else{return}
            
            self.isLoading = false
            
            if let error = error{
                self.showError = error
                return
            }
            if let cars = cars{
                self.convertModelToViewModels(cars: cars)
            }
        }
    }
    private func convertModelToViewModels(cars: carList){
        
        self.items =  cars.compactMap { car in
            return CarListItemViewModel.init(model:car)
        }
    }
}
