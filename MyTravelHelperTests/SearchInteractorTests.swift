//
//  SearchInteractorTests.swift
//  MyTravelHelperTests
//
//  Created by Vinoth on 19/10/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import XCTest

@testable import MyTravelHelper

class SearchInteractorTests: XCTestCase {
    
    var searchTrainInteractor: SearchTrainInteractor!
    
    var presenter: SearchTrainPresenterMock!
    var view = SearchTrainMockView()

    override func setUp() {
        super.setUp()
        searchTrainInteractor = SearchTrainInteractor()
        presenter = SearchTrainPresenterMock()
    }

    override func tearDown() {
        super.tearDown()
        searchTrainInteractor = nil
    }
    
    func checkNetwork() {
        XCTAssert(Reach().isNetworkReachable(), "Network connection available...")
    }
}

class SearchTrainPresenterMock: ViewToPresenterProtocol {
    var view: PresenterToViewProtocol?
    var stationsList = [Station]()
    var interactor: PresenterToInteractorProtocol?
    
    var router: PresenterToRouterProtocol?
    
    func fetchallStations() { }
    
    func searchTapped(source: String, destination: String) {
        let station1 = Station(desc: "Belfast Central", latitude: 54.6123, longitude: -5.91744, code: "BFSTC", stationId: 228)
        let station2 = Station(desc: "Burn", latitude: 34.6123, longitude: -15.91744, code: "lburn", stationId: 220)
    }
    
    func showMessage(_ msg: String) {
        
    }
}
