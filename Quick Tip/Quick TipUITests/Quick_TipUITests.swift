//
//  Quick_TipUITests.swift
//  Quick TipUITests
//
//  Created by Anjali Kevadiya on 6/12/20.
//  Copyright © 2020 Anjali Kevadiya. All rights reserved.
//

import XCTest

class Quick_TipUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        
        //The setup function is called before each test, so we initialise a new application instance each time around.

        super.setUp()
        continueAfterFailure = false //This defines that if one test fails then we should not continue to run the rest
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testClearEverythingButtonDisplays() {
        app.launch()
        XCTAssertTrue(app.buttons["Clear Everything"].exists)
    }
    
    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
