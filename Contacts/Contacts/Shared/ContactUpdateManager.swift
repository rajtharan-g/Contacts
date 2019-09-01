//
//  ContactUpdateManager.swift
//  Contacts
//
//  Created by Rajtharan G on 01/09/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import Foundation

protocol NetworkSession {
    func loadData(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    func updateData(from url: URL, type: EditContactType, json: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class ContactUpdateManager {
    
    private let session: NetworkSession
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func toggleFavouriteStatus(contact: Contact, completionHandler: @escaping (ContactDetail?, Error?) -> Void) {
        guard let contactId = contact.id else { fatalError("Contact ID can't be empty") }
        guard let url = URL(string: "\(kContactURL)/\(contactId).json") else { fatalError("URL can't be empty") }
        updateContact(url: url, type:.update, json: ["favorite" : !(contact.isFavourite ?? false)]) { (data, response, error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            guard let data = data else {
                completionHandler(nil, NSError(domain: "no data", code: 10, userInfo: nil))
                return
            }
            do {
                let contact = try JSONDecoder().decode(ContactDetail.self, from: data)
                completionHandler(contact, nil)
            } catch let error {
                completionHandler(nil, error)
            }
        }
    }
    
    func updateContact(contactDetail: ContactDetail, json: [String: Any?], completionHandler: @escaping (ContactDetail?, Error?) -> Void) {
        guard let contactId = contactDetail.id else { fatalError("Contact ID can't be empty") }
        guard let url = URL(string: "\(kContactURL)/\(contactId).json") else { fatalError("URL can't be empty") }
        updateContact(url: url, type: .update, json: json as [String : Any]) { (data, response, error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            guard let data = data else {
                completionHandler(nil, NSError(domain: "no data", code: 10, userInfo: nil))
                return
            }
            do {
                let contact = try JSONDecoder().decode(ContactDetail.self, from: data)
                completionHandler(contact, nil)
            } catch let error {
                completionHandler(nil, error)
            }
        }
    }
    
    func updateContact(url:URL, type:EditContactType, json:[String: Any],  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session.updateData(from: url, type: type, json: json, completionHandler: completionHandler)
    }
    
}

extension URLSession: NetworkSession {
    
    func loadData(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: url) { (data, response, error) in
            completionHandler(data, response, error)
        }.resume()
    }
    
    func updateData(from url: URL, type: EditContactType, json: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = type == EditContactType.update ? "PUT" : "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        request.httpBody = jsonData
        dataTask(with: request) { data, response, error in
            completionHandler(data, response, error)
        }.resume()
    }
    
}
