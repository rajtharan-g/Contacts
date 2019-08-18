//
//  MockObjects.swift
//  ContactsTests
//
//  Created by Rajtharan G on 18/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit
@testable import Contacts

extension ContactDetail {
    
    static func mockWith(id: Int = 0, firstname: String = "Rajtharan", lastname: String = "G", contactImage: String = "", isFavourite: Bool = true, url:String = "") -> ContactDetail {
        return ContactDetail(id: id, firstName: firstname, lastName: lastname, contactImage: contactImage, isFavourite: isFavourite, url: url)
    }
    
}
