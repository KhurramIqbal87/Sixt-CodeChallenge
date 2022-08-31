//
//  MapViewController.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import UIKit

import UIKit
import Combine

/// MapviewController is dependent on MapViewModel Type. We take viewModel on initializer. We have to create viewController manually else it will give error

///       fatalError("init(coder:) has not been implemented")

/// MapviewController handles error receive on view Model at times of network communication

/// MapviewController receives latest location and radius of map from map publisher and gives it to viewModel to recieve filtered driver data through its published property.

/// MapViewController has a refesh button at top used to get the latest data

final class MapViewController<T: MapViewModelType>: BaseViewController<T> {
   
    //MARK: - IBOutlets
    
    @IBOutlet weak var mapView: CustomMap!
    
    //MARK: - StoreProperties
    
    private var cancelable: Set<AnyCancellable> = []
    private let mapViewModel: CustomMapViewModelType
    
    //MARK: - Initializers
    
    init(viewModel: T, mapViewModel: CustomMapViewModelType){
        
        self.mapViewModel = mapViewModel
        super.init(T: viewModel  , nibName: "MapViewController")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewLifeCycles
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
       /// set mapviewModel
        self.mapView.setViewModel(viewModel: self.mapViewModel)
        self.setupMapView()
        self.setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.title = self.viewModel.getTitle()
    }
    
    //MARK: - IBActions
    @IBAction func refresh(_ sender: Any) {
        self.viewModel.refresh()
    }
    
}
extension MapViewController{
    
    //MARK: - Helpers
    private func setupViewModel(){
       ///
        self.viewModel.filterDriverPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] drivers in
                
                self?.mapView.drivers.send(drivers)
            }
            .store(in: &cancelable)
        
        
      /// show hide loader when calling service
        self.viewModel.loadingPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] loading in
               
                if loading{
                    self?.showLoader()
                }else{
                    self?.hideLoader()
                }
            }
            .store(in: &cancelable)
        
        /// Show error when get error from service end
        self.viewModel.errorPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
               
                if error.isEmpty {return}
                
                self?.showError(title: "Error", message: error)
            }
            .store(in: &cancelable)
        
    }
    
    func setupMapView(){
        
        /// on location update ask viewmodel to give filtered list to display on map
        let subscriber = self.mapView.$updatedLocation
            .sink { [weak self] updatedLocation in
           
            guard let self = self else{return}
           
            if let location = updatedLocation.currentLocatiion, let radius = updatedLocation.radius{
                
                print("Sinked Location:", location)
                print("Sinked Radius", radius)
                
                self.viewModel.getFilteredDrivers(currentLocation: location, radius: radius, refresh: false)
            }
        }
        self.cancelable.insert(subscriber)
    }
}

