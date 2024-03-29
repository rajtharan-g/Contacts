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
    
    var session: URLSession!
    let nonLetterIndex = "#"
    var titleIndexArray: [String] = Array()
    
    // MARK: - API methods
    
    init(session: URLSession? = URLSession.shared) {
        if CommandLine.arguments.contains("--uitesting") {
            let jsonData = "[{\"id\":10139,\"first_name\":\"aakam\",\"last_name\":\"kumfasfsd\",\"profile_pic\":\"/images/missing.png\",\"favorite\":true,\"url\":\"http://gojek-contacts-app.herokuapp.com/contacts/10139.json\"},{\"id\":10141,\"first_name\":\"akam \",\"last_name\":\"kkkk\",\"profile_pic\":\"/images/missing.png\",\"favorite\":true,\"url\":\"http://gojek-contacts-app.herokuapp.com/contacts/10141.json\"}]".data(using: .utf8)
            self.session = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        } else {
            self.session = session
        }
    }
    
    func getContacts(completionHandler: @escaping ([Contact]?, Error?) -> Void) {
        guard let url = URL(string: kContactsJsonURL) else { fatalError("URL can't be empty") }
        session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            guard let data = data else {
                completionHandler(nil, NSError(domain: "no data", code: 10, userInfo: nil))
                return
            }
            do {
                let contacts = try JSONDecoder().decode([Contact].self, from: data)
                completionHandler(contacts, nil)
            } catch let error {
                completionHandler(nil, error)
            }
        }.resume()
    }
    
    func getContactDetail(contact:Contact, completionHandler: @escaping (ContactDetail?, Error?) -> Void) {
        guard let contactId = contact.id else { fatalError("Contact ID can't be empty") }
        guard let url = URL(string: "\(kContactURL)/\(contactId).json") else { fatalError("URL can't be empty") }
        session.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            guard let data = data else {
                completionHandler(nil, NSError(domain: "no data", code: 10, userInfo: nil))
                return
            }
            do {
                let contacts = try JSONDecoder().decode(ContactDetail.self, from: data)
                completionHandler(contacts, nil)
            } catch let error {
                completionHandler(nil, error)
            }
        }).resume()
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
        var contactsDict: [String: [Contact]] = Dictionary()
        for contact in contacts {
            let indexKey = contact.fullName().first?.uppercased() ?? ""
            if !titleIndexArray.contains(indexKey) {
                if Character(indexKey).isLetter {
                    titleIndexArray.append(indexKey)
                } else {
                    titleIndexArray.append(nonLetterIndex)
                }
            }
        }
        titleIndexArray.sort()
        for key in titleIndexArray {
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

