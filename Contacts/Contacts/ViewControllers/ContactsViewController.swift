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
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var groupsBarButtonItem: UIBarButtonItem!
    
    static let sectionHeaderHeight: CGFloat = 45.0
    
    var contacts: [Contact]?
    var contactsDict: [String: [Contact]]?
    
    // MARK: - View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyUICustomization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchContacts()
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
    
    func applyUICustomization() {
        
        // Color
        groupsBarButtonItem.applyTintColor(color: UIColor.menuGreenColor())
        addBarButtonItem.applyTintColor(color: UIColor.menuGreenColor())
        contactsTableView.sectionIndexColor = UIColor.gray
        contactsTableView.separatorColor = UIColor.veryLightGray()
        
        // Title text
        title = "Contact"
        navigationController?.navigationBar.titleTextAttributes = ContactsManager.navigationTitleTextAttributes()
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.backgroundView?.backgroundColor = UIColor.lightGray()
            header.textLabel?.textColor = UIColor.black
            header.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        }
    }
    
}

// MARK: - UITableViewDelegate methods

extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ContactTableViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ContactsViewController.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}
