//
//  ContactUpdateTests.swift
//  ContactsTests
//
//  Created by Rajtharan G on 01/09/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactUpdateTests: XCTestCase {

    static let responseTimeOut = 10.0
    
    var promise: XCTestExpectation!
    var mockURLSession: MockNetworkSession!
    var contactUpdateManager: ContactUpdateManager!
    var mockContact: Contact!
    
    // MARK: - Test life cycle methods
    
    override func setUp() {
        super.setUp()
        mockContact = ContactDetail.mockWith(id: 9344)
    }
    
    override func tearDown() {
        super.tearDown()
        mockContact = nil
    }
    
    
    // MARK: - Test methods
    
    func testToggleFavoritesWithExpectedURLHostAndPath() {
        mockURLSession = MockNetworkSession(data: nil, urlResponse: nil, error: nil)
        contactUpdateManager = ContactUpdateManager(session: mockURLSession)
        contactUpdateManager.toggleFavouriteStatus(contact: mockContact) { (_, _) in }
        XCTAssertEqual(mockURLSession.cachedURL?.host, "gojek-contacts-app.herokuapp.com")
        XCTAssertEqual(mockURLSession.cachedURL?.path, "/contacts/9344.json")
    }
    
    func testToggleFavoritesSuccessReturnsContacts() {
        let jsonData = #"{"id":9344,"first_name":"akam ","last_name":"kkkk","email":"fsdfsdfsfd@dff.com","phone_number":"3424242423434233","profile_pic":"/images/missing.png","favorite":true,"created_at":"2019-08-31T06:14:08.030Z","updated_at":"2019-08-31T06:14:08.030Z"}"#.data(using: .utf8)
        mockURLSession = MockNetworkSession(data: jsonData, urlResponse: nil, error: nil)
        contactUpdateManager = ContactUpdateManager(session: mockURLSession)
        let contactsExpectation = expectation(description: "contacts")
        var contactResponse: Contact?
        let mockContact = ContactDetail.mockWith(id: 9344)
        contactUpdateManager.toggleFavouriteStatus(contact: mockContact) { (contactDetail, error) in
            contactResponse = contactDetail
            contactsExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(contactResponse)
        }
    }
    
    func testToggleFavoritesWhenResponseErrorReturnsError() {
        let error = NSError(domain: "error", code: 1234, userInfo: nil)
        mockURLSession = MockNetworkSession(data: nil, urlResponse: nil, error: error)
        contactUpdateManager = ContactUpdateManager(session: mockURLSession)
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?
        let mockContact = ContactDetail.mockWith(id: 9344)
        contactUpdateManager.toggleFavouriteStatus(contact: mockContact) { (contacts, error) in
            errorResponse = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    func testToggleFavoritesWhenEmptyDataReturnsError() {
        mockURLSession = MockNetworkSession(data: nil, urlResponse: nil, error: nil)
        contactUpdateManager = ContactUpdateManager(session: mockURLSession)
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?
        let mockContact = ContactDetail.mockWith(id: 9344)
        contactUpdateManager.toggleFavouriteStatus(contact: mockContact) { (contacts, error) in
            errorResponse = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    func testToggleFavoritesInvalidJSONReturnsError() {
        let jsonData = "[{\"t\"}]".data(using: .utf8)
        mockURLSession = MockNetworkSession(data: jsonData, urlResponse: nil, error: nil)
        contactUpdateManager = ContactUpdateManager(session: mockURLSession)
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?
        let mockContact = ContactDetail.mockWith(id: 9344)
        contactUpdateManager.toggleFavouriteStatus(contact: mockContact) { (contacts, error) in
            errorResponse = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }

}
