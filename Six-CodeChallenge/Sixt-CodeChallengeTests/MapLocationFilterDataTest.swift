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

/// this test class test MapViewModelType by providing mock drivers data. testing if it reutrns right number of filteredDriver through its published property by providing mock location and radius to its api.

class MapLocationFilterDataTest: XCTestCase {
   
    var sut: MapViewModelType!
    var anyCancelables: Set<AnyCancellable> = []
   
    override func setUpWithError() throws {
    }
    
    override func setUp() {
        super.setUp()
        let mockRepo = MockDriverListRepository.init()
       
        let expectation = XCTestExpectation.init(description: "Mock Data")
      
        mockRepo.getDriverList() { [weak self] drivers, error in
            self?.sut = MapViewModel.init(repo: mockRepo,drivers: drivers ?? [])
            expectation.fulfill()
            
        }
        wait(for: [expectation], timeout: 10)
        
        
    }
    
    func testFilteredDriverWithLocation(){
      
        sut.getFilteredDrivers(currentLocation: CLLocationCoordinate2D.init(latitude: 48.162771, longitude: 11.592978), radius: 2000, refresh: false)
        
        let expectation = XCTestExpectation(description: "Should filter data and count should be 1.")
        
        sut.filterDriverPublisher
            .receive(on: RunLoop.main)
            .sink { drivers in
              
                XCTAssert(drivers.count ==  1)
                expectation.fulfill()
            }
            .store(in: &anyCancelables)
        
        wait(for: [ expectation ], timeout: 15)
        
    }

}
