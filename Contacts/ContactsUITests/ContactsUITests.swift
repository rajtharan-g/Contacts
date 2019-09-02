//
//  ContactsUITests.swift
//  ContactsUITests
//
//  Created by Rajtharan G on 17/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import XCTest

class ContactsUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testContactsTableViewInteraction() {
        app.launch()
        let predicate = NSPredicate(format: "exists == true")
        let query = app.tables["contactsTableView"]
        expectation(for: predicate, evaluatedWith: query, handler: nil)
        waitForExpectations(timeout: 1.0, handler: nil)
        sleep(1) // UI exists even before it actually appears in screen, so we are adding 1 second delay to it
        
        let contactsTableView = app.tables["contactsTableView"]
        XCTAssertTrue(contactsTableView.exists, "The contacts tableview exists")
        let tableCells = contactsTableView.cells
        if tableCells.count > 0 {
            let count = min(tableCells.count - 1, 2) // Test maximum of two cells
            let promise = expectation(description: "Wait for table cells")
            for i in stride(from: 0, to: count , by: 1) {
                
                // Grab the cell and verify that it exists and tap it
                let tableCell = tableCells.element(boundBy: i)
                XCTAssertTrue(tableCell.exists, "The \(i) cell is in place on the table")
                
                tableCell.tap()
                
                if i == (count - 1) {
                    promise.fulfill()
                }
                
                // Back
                app.navigationBars.buttons.element(boundBy: 0).tap()
            }
            waitForExpectations(timeout: 3.0, handler: nil)
            XCTAssertTrue(true, "Finished testing the table cells")
        } else {
            XCTAssert(false, "Table view cells not found")
        }
    }
    
    func testContactDetail() {
        app.launch()
        let tableCells = app.tables["contactsTableView"].cells
        if tableCells.count > 0 {
            let promise = expectation(description: "Wait for table cells")
            let tableCell = tableCells.firstMatch
            tableCell.tap()
        
            // Check if all buttons exist
            XCTAssertTrue(app.buttons["callActionViewButton"].exists)
            XCTAssertTrue(app.buttons["emailActionViewButton"].exists)
            XCTAssertTrue(app.buttons["messageActionViewButton"].exists)
            XCTAssertTrue(app.buttons["favoriteActionViewButton"].exists)
            
            promise.fulfill()
            waitForExpectations(timeout: 20.0, handler: nil)
        } else {
            XCTAssert(false, "Table view cells not found")
        }
    }
    
    func testEditContact() {
        app.launch()
        let tableCells = app.tables["contactsTableView"].cells
        if tableCells.count > 0 {
            let promise = expectation(description: "Wait for table cells")
            let tableCell = tableCells.firstMatch
            tableCell.tap()
            
            // Edit button pressed
            app.navigationBars.buttons.element(boundBy: 1).tap()
            
            // Check if all labels exists in edit screen
            XCTAssertTrue(app.staticTexts["firstNameLabel"].exists)
            XCTAssertTrue(app.staticTexts["lastNameLabel"].exists)
            XCTAssertTrue(app.staticTexts["mobileLabel"].exists)
            XCTAssertTrue(app.staticTexts["emailLabel"].exists)
            
            promise.fulfill()
            waitForExpectations(timeout: 20.0, handler: nil)
        } else {
            XCTAssert(false, "Table view cells not found")
        }
    }
    
    func goBackgroundAndForeground() {
        XCUIDevice.shared.press(.home)
        app.activate()
    }
    
    func killAndOpenApp() {
        app.terminate()
        app.launch()
    }
    
}
