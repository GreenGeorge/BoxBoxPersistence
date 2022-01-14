//
//  BoxBoxPersistenceTests.swift
//  BoxBoxPersistenceTests
//
//  Created by George Ananda on 14/01/22.
//

import XCTest
@testable import BoxBoxPersistence

class BoxBoxPersistenceTests: XCTestCase {
    let persistence = BoxBoxPersistence.shared

    override func setUpWithError() throws {
        let container = persistence.container
        let driver = DriverMO(context: container.viewContext)
        driver.firstName = "George"
        driver.lastName = "Ananda"
        driver.code = "ANA"
        driver.number = "98"
        driver.nationality = "Indonesian"
        driver.position = 1
        
        let season = SeasonMO(context: container.viewContext)
        season.title = "2021"
        
        let constructor = ConstructorMO(context: container.viewContext)
        constructor.constructorId = "mercedes"
        
        driver.addToSeason(season)
        driver.addToConstructor(constructor)
        
        persistence.save()
    }

    override func tearDownWithError() throws {
    }

    func testExample() throws {
        persistence.getDrivers(for: "2021") { result in
            switch result {
            case .success(let drivers):
                if(drivers.first!.lastName == "Ananda") {
                    XCTAssert(true)
                }
            case.failure(let error):
                XCTAssert(false, error.localizedDescription)
            }
        }
    }
    
}
