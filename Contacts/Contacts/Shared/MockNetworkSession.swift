//
//  NetworkSessionMock.swift
//  Contacts
//
//  Created by Rajtharan G on 01/09/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import Foundation

class MockNetworkSession {
    
    var cachedURL: URL?
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data:Data? = nil, urlResponse: URLResponse? = nil, error: Error? = nil) {
        self.data = data
        self.response = urlResponse
        self.error = error
    }
    
}

extension MockNetworkSession: NetworkSession {
    
    func loadData(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.cachedURL = url
        completionHandler(data, response, error)
    }
    
    func updateData(from url: URL, type: EditContactType, json: [String : Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.cachedURL = url
        completionHandler(data, response, error)
    }
    
}
