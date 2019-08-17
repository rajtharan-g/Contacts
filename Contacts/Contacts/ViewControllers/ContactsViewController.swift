//
//  ViewController.swift
//  Contacts
//
//  Created by Rajtharan G on 17/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var contactsTableView: UITableView!
    
    var contacts: [Contact]?
    var contactsDict: [String: [Contact]]?
    
    // MARK: - View life cycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchContacts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Custom methods
    
    func fetchContacts() {
        ContactsManager.shared.fetchContacts { (contactsDict, error) in
            DispatchQueue.main.async {
                self.contactsDict = contactsDict
                self.contactsTableView.reloadData()
            }
        }
    }

}

// MARK: - UITableViewDataSource methods

extension ContactsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactsDict?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let keys = contactsDict?.keys.sorted() {
            let indexKey = Array(keys)[section]
            return contactsDict?[indexKey]?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let contactCell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier) as? ContactTableViewCell {
            if let keys = contactsDict?.keys.sorted() {
                let indexKey = Array(keys)[indexPath.section]
                if let contact = contactsDict?[indexKey]?[indexPath.row] {
                    contactCell.updateCell(contact: contact)
                }
            }
            return contactCell
        }
        return UITableViewCell()
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactsDict?.keys.sorted()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactsDict?.keys.sorted()[section]
    }
    
}

// MARK: - UITableViewDelegate methods

extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
