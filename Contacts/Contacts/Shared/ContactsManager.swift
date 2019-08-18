//
//  ContactsManager.swift
//  Contacts
//
//  Created by Rajtharan G on 17/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

let kBaseURL = "http://gojek-contacts-app.herokuapp.com/"
let kContactsJsonURL = "\(kBaseURL)contacts.json"
let kContactURL = "\(kBaseURL)contacts"

class ContactsManager: NSObject {
    
    static let shared = ContactsManager()
    
    let nonLetterIndex = "#"
    
    // MARK: - API methods
    
    func fetchContacts(completionHandler: @escaping ([String: [Contact]]?, Error?) -> Void) {
        if let url = URL(string: kContactsJsonURL) {
            URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: { (data, response, error) -> Void in
                guard let data = data else {
                    print("Error: No data to decode")
                    completionHandler(nil, error)
                    return
                }
                guard let contacts = try? JSONDecoder().decode([Contact].self, from: data) else {
                    print("Error: Couldn't decode data into Contact")
                    completionHandler(nil, error)
                    return
                }
                completionHandler(self.sortContacts(contacts: contacts), error)
            }).resume()
        }
    }
    
    func fetchContactDetail(contact:Contact, completionHandler: @escaping (ContactDetail?, Error?) -> Void) {
        if let contactId = contact.id, let url = URL(string: "\(kContactURL)/\(contactId).json") {
            URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: { (data, response, error) -> Void in
                guard let data = data else {
                    print("Error: No data to decode")
                    completionHandler(nil, error)
                    return
                }
                guard let contact = try? JSONDecoder().decode(ContactDetail.self, from: data) else {
                    print("Error: Couldn't decode data into Contact")
                    completionHandler(nil, error)
                    return
                }
                completionHandler(contact, error)
            }).resume()
        }
    }
    
    func updateFavouriteStatus(contactDetail: ContactDetail?, completionHandler: @escaping (ContactDetail?, Error?) -> Void) {
        if let contactId = contactDetail?.id, let url = URL(string: "\(kContactURL)/\(contactId).json") {
            updateContact(url: url, type:.update, json: ["favorite" : !(contactDetail?.isFavourite ?? false)]) { (data, response, error) in
                if error == nil {
                    contactDetail?.isFavourite = !(contactDetail?.isFavourite ?? false)
                }
                completionHandler(contactDetail, error)
            }
        }
    }
    
    func updateContactDetail(contactDetail: ContactDetail?, json: [String: String?]?, completionHandler: @escaping (ContactDetail?, Error?) -> Void) {
        if let contactId = contactDetail?.id, let url = URL(string: "\(kContactURL)/\(contactId).json"), let json = json {
            updateContact(url: url, type: .update, json: json as [String : Any]) { (data, response, error) in
                guard let data = data else {
                    print("Error: No data to decode")
                    completionHandler(nil, error)
                    return
                }
                guard let contact = try? JSONDecoder().decode(ContactDetail.self, from: data) else {
                    print("Error: Couldn't decode data into Contact")
                    completionHandler(nil, error)
                    return
                }
                completionHandler(contact, error)
            }
        }
    }
    
    func createContactDetail(json: [String: String?]?, completionHandler: @escaping (ContactDetail?, Error?, ValidationError?) -> Void) {
        if let url = URL(string: "\(kContactURL).json"), let json = json {
            updateContact(url: url, type: .create, json: json as [String : Any]) { (data, response, error) in
                guard let data = data else {
                    print("Error: No data to decode")
                    completionHandler(nil, error, nil)
                    return
                }
                guard let contact = try? JSONDecoder().decode(ContactDetail.self, from: data) else {
                    print("Error: Couldn't decode data into Contact")
                    guard let errors = try? JSONDecoder().decode(ValidationError.self, from: data) else {
                        print("Error: Couldn't decode data into ValidationError")
                        completionHandler(nil, error, nil)
                        return
                    }
                    completionHandler(nil, nil, errors)
                    return
                }
                completionHandler(contact, error, nil)
            }
        }
    }
    
    func updateContact(url:URL, type:EditContactType, json:[String: Any],  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = type == EditContactType.update ? "PUT" : "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { data, response, error in
            completionHandler(data, response, error)
        }.resume()
    }
    
    // MARK: - Custom methods
    
    func sortContacts(contacts: [Contact]) -> [String: [Contact]] {
        var contactsDict: [String: [Contact]] = [:]
        for contact in contacts {
            let indexKey = contact.fullName().first?.uppercased() ?? ""
            if !Array(contactsDict.keys).contains(indexKey) && Character(indexKey).isLetter {
                contactsDict[indexKey] = Array()
            } else {
                contactsDict[nonLetterIndex] = Array()
            }
        }
        let sortedKeys = Array(contactsDict.keys).sorted(by: <)
        for key in sortedKeys {
            if Character(key).isLetter {
                contactsDict[key] = contacts.filter({$0.fullName().first?.uppercased() ?? "" == key}).sorted(by: {$0.fullName() < $1.fullName()})
            } else {
                contactsDict[key] = contacts.filter({!Character($0.fullName().first?.uppercased() ?? "").isLetter})
            }
        }
        return contactsDict
    }
    
    class func navigationTitleTextAttributes() -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor: UIColor.appBlackColor(), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: .semibold)]
    }

}

