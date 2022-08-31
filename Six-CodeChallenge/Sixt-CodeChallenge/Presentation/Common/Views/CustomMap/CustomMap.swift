//
//  CustomMap.swift
//  Sixt-CodeChallenge
//
//  Created by Khurram Iqbal on 30/08/2022.
//

import UIKit
import Foundation
import MapKit
import Combine

 final class CustomMap: UIView, CustomMapType {
 
//MARK: - IBOutlets
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var currentLocationView: UIView!
    
//MARK: - StoredProperties
   
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    private var cancelable = [AnyCancellable]()
    
    private var viewModel: CustomMapViewModelType?
    private let annotationReusableIdentifier =  "Annotation"
   
    var drivers: PassthroughSubject<[Driver], Never> = PassthroughSubject<[Driver], Never>()
    
    @Published var updatedLocation : UpdatedLocation = UpdatedLocation()
 
    //MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let xibView = Bundle.main.loadNibNamed("CustomMap", owner: self, options: nil)!.first as! UIView
        
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(xibView)
        
        self.setup()
    }
}

// MARK: - setup functions
extension CustomMap{
    
    private func setup(){
        
        let cancelable =  self.drivers.sink { [weak self] drivers in            self?.setAnnotations(drivers: drivers)
        }
        
        self.cancelable.append(cancelable)
        self.mapView.mapType = .standard
        self.currentLocationView.roundCorner()
    }
    
    func setViewModel(viewModel: CustomMapViewModelType){
        
        self.viewModel = viewModel
        self.mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
     
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - Helper Functions
extension CustomMap{
    
    private func setAnnotations(drivers: [Driver]){
        // remove all previouse annotation
        self.removeAnnotations()
       
        // add new annotation for updated location
        for driver in drivers{
            
            let annotation = CarAnnotation.init()
           
            annotation.imageURL = driver.carImageURL
            annotation.coordinate = driver.getCLCoordinate()
          
            self.mapView.addAnnotation(annotation)
        }
    }
    
    private func removeAnnotations(){
        
        let annotations = self.mapView?.annotations.filter{$0 !== self.mapView?.userLocation} ?? []
        
        self.mapView?.removeAnnotations(annotations)
    }
}

//MARK: - MKMapViewDelegate
extension CustomMap: MKMapViewDelegate{
   
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       
        if annotation is MKUserLocation{
            return nil
        }
        /// Deque annotation view
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: self.annotationReusableIdentifier)
        
        /// check if nil create a new annotaion view else reuse the object
        if annotationView == nil {
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: self.annotationReusableIdentifier)
            
            annotationView!.canShowCallout = true
            
        } else {
            annotationView!.annotation = annotation
        }
        annotationView?.canShowCallout = true
        
        /// get image from viewModel
        if let carAnnotation = annotation as? CarAnnotation, let imageUrl = carAnnotation.imageURL{
            
            self.viewModel?.getImage(imagePath: imageUrl, completion: { [weak annotationView] imageData in
                
                if let imageData = imageData, let image = UIImage.init(data: imageData){
                
                    DispatchQueue.main.async {
                 
                    annotationView?.image = image
                    annotationView?.frame.size = CGSize(width: 50, height: 50)
                }
            }
        })
    }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        // on region change change and animate the center dot color
        self.currentLocationView.backgroundColor = .orange
    }
    
    /// on region changed create a new object of updated location so viewController ka recieve new value and ask viewModel to filter list of driver with respect to current locationn
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
       
        UIView.animate(withDuration: 0.1) {
            self.currentLocationView.backgroundColor = UIColor.green
        }
      
        self.updatedLocation = UpdatedLocation.init(currentLocatiion: mapView.centerCoordinate, radius: mapView.currentRadius())
    }
    
}

// MARK: - CLLocationManagerDelegate
extension CustomMap: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                
                let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                
                mapView.setRegion(viewRegion, animated: false)
                
            }
        }
    }
}


// To handle map in a different class at time if we want to change the implementation we can with zero effect on our viewController end
protocol CustomMapType{
    var updatedLocation : UpdatedLocation{get}
    var drivers: PassthroughSubject<[Driver],Never>{get}
}


