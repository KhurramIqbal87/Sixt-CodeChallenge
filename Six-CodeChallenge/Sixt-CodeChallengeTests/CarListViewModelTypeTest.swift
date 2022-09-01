//
//  CarListViewModelTypeTest.swift
//  Sixt-CodeChallengeTests
//
//  Created by Khurram Iqbal on 31/08/2022.
//

import XCTest
import Combine

@testable import Sixt_CodeChallenge

class CarListViewModelTypeTest: XCTestCase {

    var sut: CarListViewModelType!
    
    let stream = PassthroughSubject<[CarListItemViewModelType],Never>()
    
    let loading = PassthroughSubject<Bool,Never>()
    
    var anyCancelables:Set<AnyCancellable> = []
   
    override func setUp() {
       
        super.setUp()

        let repo = MockCarListRepository.init()
        sut = CarListViewModel.init(repository: repo)
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }

   
    func testViewDidLoadState(){
        sut.viewDidLoad()
        
        let expectation = XCTestExpectation.init(description: "Cars should be greater than 0")
        
        sut.itemsPublisher
            .receive(on: RunLoop.main)
            .sink { carList in
                
                XCTAssert(carList.count > 0)
                expectation.fulfill()
            }.store(in: &anyCancelables)
        
        wait(for: [expectation], timeout: 10)
    }

}
