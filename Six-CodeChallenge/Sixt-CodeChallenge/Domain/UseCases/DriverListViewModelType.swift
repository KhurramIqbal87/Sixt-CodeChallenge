//
//  DriverListViewModelType.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import Foundation
import Combine
import CoreLocation
/// to enable our DriverListViewController to work with any implementation we have created the abstraction Layer so we can make our code testable
/// DriverListViewModelType used Combine to published its data, error handling, and handle loading states.

protocol DriverListViewModelType: BaseViewModel{
  
    //MARK: - StoredProperties
    
    var itemsPublisher: Published<[DriverListItemViewModelType]>.Publisher{get}
    var loadingPublisher: Published<Bool>.Publisher {get}
    var errorPublisher: Published<String>.Publisher{get}
    
    //MARK: - Functionalities
    func viewDidLoad()
    func refresh()
    func getTitle()->String
  
}
