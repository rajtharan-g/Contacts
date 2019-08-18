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
    static let cellHeight: CGFloat = 64.0
    
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyUICustomization()
    }
    
    // MARK: - Custom methods
    
    func updateCell(contact: Contact) {
        contactName.text = contact.fullName()
        contactImageView.load(urlString: contact.contactImage)
        favoriteImageView.isHidden = contact.isFavourite != true
    }
    
    func applyUICustomization() {
        
        // Color
        contactName.textColor = UIColor.appBlackColor()
        
        // Font
        contactName.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        
        // UI
        favoriteImageView.rounded()
        
        // Setup XCUITest Accessibility identifer
        favoriteImageView.accessibilityIdentifier = "favoriteImageView"
        contactName.accessibilityIdentifier = "contactName"
        contactImageView.accessibilityIdentifier = "contactImageView"
    }

}
