//
//  ContactsManager.swift
//  Contacts
//
//  Created by Rajtharan G on 17/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

let kBaseURL = "http://gojek-contacts-app.herokuapp.com/"
let kContactsURL = "\(kBaseURL)contacts.json"

class ContactsManager: NSObject {
    
    static let shared = ContactsManager()
    
    let nonLetterIndex = "#"
    
    func fetchContacts(completionHandler: @escaping ([String: [Contact]]?, Error?) -> Void) {
        if let url = URL(string: kContactsURL) {
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
                completionHandler(self.sortContacts(contacts: contacts), nil)
            }).resume()
        }
    }
    
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

