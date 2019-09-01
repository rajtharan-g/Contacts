//
//  MockDataTask.swift
//  Contacts
//
//  Created by Rajtharan G on 01/09/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import Foundation

class MockDataTask: URLSessionDataTask {
    
    private let data: Data?
    private let urlResponse: URLResponse?
    private let errorResponse: Error?
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    init(data:Data?, urlResponse: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.errorResponse = error
    }
    
    override func resume() {
        DispatchQueue.main.async {
            if let completion = self.completionHandler {
                completion(self.data, self.urlResponse, self.errorResponse)
            }
        }
    }
    
}
