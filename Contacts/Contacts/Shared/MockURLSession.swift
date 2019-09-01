//
//  MockURLSession.swift
//  Contacts
//
//  Created by Rajtharan G on 01/09/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import Foundation

class MockURLSession:URLSession {
    
    var cachedURL: URL?
    private let mockTask: MockDataTask
    
    init(data:Data? = nil, urlResponse: URLResponse? = nil, error: Error? = nil) {
        mockTask = MockDataTask(data: data, urlResponse: urlResponse, error: error)
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.cachedURL = url
        mockTask.completionHandler = completionHandler
        return mockTask
    }
    
}
