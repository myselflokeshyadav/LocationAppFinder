//
//  LocationFinderAppTests.swift
//  LocationFinderAppTests
//
//  Created by Atul Bhaisare on 5/21/19.
//  Copyright © 2019 Atul Bhaisare. All rights reserved.
//

import XCTest
import CoreLocation
@testable import LocationFinderApp
class LocationFinderAppTests: XCTestCase {
    var place : Place?
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let address = "22425 Market Street Cornelius, NC 28031"
        let description = "Home"
        let location = CLLocation(latitude: 10.00000, longitude: 10.00000)
        place = Place(address: address, description: description, location: location)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        place = nil
        super.tearDown()
    }

    func testSelectedLocation() {
        XCTAssertTrue(place?.address == "22425 Market Street Cornelius, NC 28031")
        XCTAssertTrue(place?.description == "Home")
    }


}
