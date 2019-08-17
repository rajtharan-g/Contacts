//
//  ContactTableViewCell.swift
//  Contacts
//
//  Created by Rajtharan G on 17/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    static let identifier = "ContactCellIdentifier"
    
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    
    func updateCell(contact: Contact) {
        contactName.text = contact.fullName()
        contactImageView.load(urlString: contact.contactImage)
        favoriteImageView.isHidden = contact.isFavourite != true
    }

}
