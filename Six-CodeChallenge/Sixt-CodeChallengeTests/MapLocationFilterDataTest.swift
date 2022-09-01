//
//  MapLocationFilterDataTest.swift
//  Sixt-CodeChallengeTests
//
//  Created by Khurram Iqbal on 31/08/2022.
//

import XCTest
import Combine
import CoreLocation
@testable import Sixt_CodeChallenge

/// this test class test MapViewModelType by providing mock cars data. testing if it reutrns right number of filteredCar through its published property by providing mock location and radius to its api.

class MapLocationFilterDataTest: XCTestCase {
   
    var sut: MapViewModelType!
    var anyCancelables: Set<AnyCancellable> = []
   
    override func setUpWithError() throws {
    }
    
    override func setUp() {
        super.setUp()
        let mockRepo = MockCarListRepository.init()
       
        let expectation = XCTestExpectation.init(description: "Mock Data")
      
        mockRepo.getCarList() { [weak self] carList, error in
           
            self?.sut = MapViewModel.init(repo: mockRepo,cars: carList ?? [])
            
            expectation.fulfill()
            
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testFilteredCarWithLocation(){
      
        sut.getFilteredCars(currentLocation: CLLocationCoordinate2D.init(latitude: 48.162771, longitude: 11.592978), radius: 2000, refresh: false)
        
        let expectation = XCTestExpectation(description: "Should filter data and count should be 1.")
        
        sut.filterCarPublisher
            .receive(on: RunLoop.main)
            .sink { carList in
              
                XCTAssert(carList.count ==  1)
                expectation.fulfill()
            }
            .store(in: &anyCancelables)
        
        wait(for: [ expectation ], timeout: 15)
    }

}
