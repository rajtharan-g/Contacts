//
//  ContactsTests.swift
//  ContactsTests
//
//  Created by Rajtharan G on 17/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactsTests: XCTestCase {
    
    static let responseTimeOut = 10.0
    
    var contactManager: ContactsManager!
    var promise: XCTestExpectation!
    
    // MARK: - Test life cycle methods
    
    override func setUp() {
        super.setUp()
        contactManager = ContactsManager.shared
    }
    
    override func tearDown() {
        contactManager = nil
        super.tearDown()
    }
    
    
    // MARK: - Test methods
    
    func testGetContactsWithExpectedURLHostAndPath() {
        let mockURLSession = MockURLSession()
        contactManager.session = mockURLSession
        contactManager.getContacts { contacts, error in }
        XCTAssertEqual(mockURLSession.cachedURL?.host, "gojek-contacts-app.herokuapp.com")
        XCTAssertEqual(mockURLSession.cachedURL?.path, "/contacts.json")
    }
    
    func testGetContactsSuccessReturnsContacts() {
        let jsonData = "[{\"id\":10139,\"first_name\":\"aakam\",\"last_name\":\"kumfasfsd\",\"profile_pic\":\"/images/missing.png\",\"favorite\":true,\"url\":\"http://gojek-contacts-app.herokuapp.com/contacts/10139.json\"},{\"id\":10141,\"first_name\":\"akam \",\"last_name\":\"kkkk\",\"profile_pic\":\"/images/missing.png\",\"favorite\":true,\"url\":\"http://gojek-contacts-app.herokuapp.com/contacts/10141.json\"}]".data(using: .utf8)
        let mockURLSession = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        contactManager.session = mockURLSession
        let contactsExpectation = expectation(description: "contacts")
        var contactsResponse: [Contact]?
        contactManager.getContacts { (contacts, error) in
            contactsResponse = contacts
            contactsExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(contactsResponse)
        }
    }
    
    func testGetContactsWhenResponseErrorReturnsError() {
        let error = NSError(domain: "error", code: 1234, userInfo: nil)
        let mockURLSession  = MockURLSession(data: nil, urlResponse: nil, error: error)
        contactManager.session = mockURLSession
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?
        contactManager.getContacts { (contacts, error) in
            errorResponse = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    func testGetContactsWhenEmptyDataReturnsError() {
        let mockURLSession  = MockURLSession(data: nil, urlResponse: nil, error: nil)
        contactManager.session = mockURLSession
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?
        contactManager.getContacts { (contacts, error) in
            errorResponse = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    func testGetContactsInvalidJSONReturnsError() {
        let jsonData = "[{\"t\"}]".data(using: .utf8)
        let mockURLSession  = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        contactManager.session = mockURLSession
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?
        contactManager.getContacts { (contacts, error) in
            errorResponse = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    func testGetContactDetailsWithExpectedURLHostAndPath() {
        let mockURLSession = MockURLSession()
        contactManager.session = mockURLSession
        let mockContact = ContactDetail.mockWith(id: 1234)
        contactManager.getContactDetail(contact: mockContact) { (_, _) in }
        XCTAssertEqual(mockURLSession.cachedURL?.host, "gojek-contacts-app.herokuapp.com")
        XCTAssertEqual(mockURLSession.cachedURL?.path, "/contacts/1234.json")
    }
    
    func testGetContactDetailsSuccessReturnsContacts() {
        let jsonData = #"{"id":10141,"first_name":"akam ","last_name":"kkkk","email":"fsdfsdfsfd@dff.com","phone_number":"3424242423434233","profile_pic":"/images/missing.png","favorite":true,"created_at":"2019-08-31T06:14:08.030Z","updated_at":"2019-08-31T06:14:08.030Z"}"#.data(using: .utf8)
        let mockURLSession = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        contactManager.session = mockURLSession
        let contactsExpectation = expectation(description: "contacts")
        var contactResponse: Contact?
        let mockContact = ContactDetail.mockWith(id: 10141)
        contactManager.getContactDetail(contact: mockContact) { (contactDetail, error) in
            contactResponse = contactDetail
            contactsExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(contactResponse)
        }
    }
    
    func testGetContactDetailsWhenResponseErrorReturnsError() {
        let error = NSError(domain: "error", code: 1234, userInfo: nil)
        let mockURLSession  = MockURLSession(data: nil, urlResponse: nil, error: error)
        contactManager.session = mockURLSession
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?
        let mockContact = ContactDetail.mockWith(id: 10141)
        contactManager.getContactDetail(contact: mockContact) { (contactDetail, error) in
            errorResponse = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    func testGetContactDetailsWhenEmptyDataReturnsError() {
        let mockURLSession  = MockURLSession(data: nil, urlResponse: nil, error: nil)
        contactManager.session = mockURLSession
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?
        let mockContact = ContactDetail.mockWith(id: 10141)
        contactManager.getContactDetail(contact: mockContact) { (contactDetail, error) in
            errorResponse = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    func testGetContactDetailsInvalidJSONReturnsError() {
        let jsonData = "[{\"t\"}]".data(using: .utf8)
        let mockURLSession  = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        contactManager.session = mockURLSession
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?
        let mockContact = ContactDetail.mockWith(id: 10141)
        contactManager.getContactDetail(contact: mockContact) { (contactDetail, error) in
            errorResponse = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    func testCreateContactDetail() {
        promise = expectation(description: "Favourite update expectation")
        let updatedJSon: [String: String] = ["first_name": "New1", "last_name": "New2", "phone_number": "9500455554", "email":"9500455554@test.com"]
        contactManager.createContactDetail(json: updatedJSon) { (contactDetail, error, validationError)  in
            XCTAssertNotNil(contactDetail, "Contact is nil")
            XCTAssertNil(error, error?.localizedDescription ?? "Error is not nil")
            XCTAssertNil(validationError, validationError?.errors?.first ?? "Validation error is not nil")
            XCTAssertEqual(contactDetail?.firstName, "New1")
            XCTAssertEqual(contactDetail?.lastName, "New2")
            XCTAssertEqual(contactDetail?.phone, "9500455554")
            XCTAssertEqual(contactDetail?.email, "9500455554@test.com")
            self.promise.fulfill()
        }
        waitForExpectations(timeout: ContactsTests.responseTimeOut, handler: nil)
    }
    
    func testInvalidContactDetail() {
        promise = expectation(description: "Favourite update expectation")
        let updatedJSon: [String: String] = ["first_name": "Invalid", "last_name": "user", "phone_number": "invalid_number", "email":"invalid_email"]
        contactManager.createContactDetail(json: updatedJSon) { (contactDetail, error, validationError)  in
            XCTAssertNil(contactDetail, "Contact is not nil for invalid update")
            XCTAssertNotNil(validationError, validationError?.errors?.first ?? "Validation error is not nil")
            XCTAssertNil(error, error?.localizedDescription ?? "Error is not nil")
            self.promise.fulfill()
        }
        waitForExpectations(timeout: ContactsTests.responseTimeOut, handler: nil)
    }
    
    func testSortContacts() {
        let contactA = ContactDetail.mockWith(id: 1, firstname: "A", lastname: "a")
        let contactB = ContactDetail.mockWith(id: 1, firstname: "B", lastname: "b")
        let contactAb = ContactDetail.mockWith(id: 1, firstname: "Ab", lastname: "ab")
        
        let sortedResult = contactManager.sortContacts(contacts: [contactB, contactA, contactAb])
        let aContacts = sortedResult["A"]
        XCTAssertNotNil(aContacts)
        
        let bContacts = sortedResult["B"]
        XCTAssertNotNil(bContacts)
        
        XCTAssertEqual(aContacts!.count, 2)
        XCTAssertEqual(aContacts![0].id, contactA.id)
        XCTAssertEqual(aContacts![1].id, contactAb.id)
        XCTAssertEqual(bContacts!.count, 1)
        XCTAssertEqual(bContacts![0].id, contactB.id)
    }
    
    func testSortContactsWithSpaecialCharacter() {
        let contactB = ContactDetail.mockWith(id: 1, firstname: "B", lastname: "b")
        let contactSpecialChar = ContactDetail.mockWith(id: 1, firstname: "12345", lastname: "5")
        let contactAb = ContactDetail.mockWith(id: 1, firstname: "Ab", lastname: "ab")
        
        let sortedResult = contactManager.sortContacts(contacts: [contactB, contactSpecialChar, contactAb])
        
        let specialCharContacts = sortedResult["#"]
        XCTAssertNotNil(specialCharContacts)
        
        let aContacts = sortedResult["A"]
        XCTAssertNotNil(aContacts)
        
        let bContacts = sortedResult["B"]
        XCTAssertNotNil(bContacts)
        
        XCTAssertEqual(specialCharContacts!.count, 1)
        XCTAssertEqual(specialCharContacts![0].id, contactSpecialChar.id)
        XCTAssertEqual(aContacts!.count, 1)
        XCTAssertEqual(aContacts![0].id, contactAb.id)
        XCTAssertEqual(bContacts!.count, 1)
        XCTAssertEqual(bContacts![0].id, contactB.id)
    }
    
    
}
