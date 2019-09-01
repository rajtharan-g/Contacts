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
    
    // MARK: - IBAction methods
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let editContactVC = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "EditContactVC") as! EditContactViewController
        editContactVC.type = .create
        present(UINavigationController(rootViewController: editContactVC), animated: true, completion: nil)
    }
    
    // MARK: - Custom methods
    
    func fetchContacts() {
        if contactsDict == nil {
            showSpinner(onView: self.view)
        }
        ContactsManager.shared.getContacts { (contacts, error) in
            DispatchQueue.main.async {
                self.removeSpinner()
                if let contacts = contacts {
                    self.contactsDict = ContactsManager.shared.sortContacts(contacts: contacts)
                }
                self.contactsTableView.reloadData()
            }
        }
    }
    
    func applyUICustomization() {
        
        // Properties
        contactsTableView.estimatedRowHeight = ContactTableViewCell.cellHeight
        
        // Color
        groupsBarButtonItem.applyTintColor(color: UIColor.menuGreenColor())
        addBarButtonItem.applyTintColor(color: UIColor.menuGreenColor())
        contactsTableView.sectionIndexColor = UIColor.gray
        contactsTableView.separatorColor = UIColor.veryLightGray()
        
        // XCUITest Accessibility identifier
        contactsTableView.accessibilityIdentifier = "contactsTableView"
        
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
        let indexKey = ContactsManager.shared.titleIndexArray[section]
        return contactsDict?[indexKey]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let contactCell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier) as? ContactTableViewCell {
            let indexKey = ContactsManager.shared.titleIndexArray[indexPath.section]
            if let contact = contactsDict?[indexKey]?[indexPath.row] {
                contactCell.updateCell(contact: contact)
            }
            return contactCell
        }
        return UITableViewCell()
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ContactsManager.shared.titleIndexArray
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ContactsManager.shared.titleIndexArray[section]
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
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contactDetailVC = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "contactDetailVC") as! ContactDetailViewController
        if let keys = contactsDict?.keys.sorted() {
            let indexKey = Array(keys)[indexPath.section]
            if let contact = contactsDict?[indexKey]?[indexPath.row] {
                contactDetailVC.contact = contact
            }
        }
        self.navigationController?.pushViewController(contactDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ContactsViewController.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}
