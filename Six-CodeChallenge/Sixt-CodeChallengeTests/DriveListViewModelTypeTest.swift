//
//  DriveListViewModelTypeTest.swift
//  Sixt-CodeChallengeTests
//
//  Created by Khurram Iqbal on 31/08/2022.
//

import XCTest
import Combine

@testable import Sixt_CodeChallenge

class DriveListViewModelTypeTest: XCTestCase {

    var sut: DriverListViewModelType!
    let stream = PassthroughSubject<[DriverListItemViewModelType],Never>()
    let loading = PassthroughSubject<Bool,Never>()
    var anyCancelables:Set<AnyCancellable> = []
    override func setUp() {
        super.setUp()
        let repo = MockDriverListRepository.init()
        sut = DriverListViewModel.init(repository: repo)
        
        
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }

   
    func testViewDidLoadState(){
        sut.viewDidLoad()
        
        let expectation = XCTestExpectation.init(description: "Drivers should be greater than 0")
        
        sut.itemsPublisher
            .receive(on: RunLoop.main)
            .sink { driver in
                
                XCTAssert(driver.count > 0)
                expectation.fulfill()
            }.store(in: &anyCancelables)
        
        wait(for: [expectation], timeout: 10)
       
    }

}
