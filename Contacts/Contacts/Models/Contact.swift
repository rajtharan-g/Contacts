//
//  Contact.swift
//  Contacts
//
//  Created by Rajtharan G on 17/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

class Contact: Decodable {
    
    var id: Int?
    var firstName: String?
    var lastName: String?
    var contactImage: String?
    var isFavourite: Bool?
    var url: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case contactImage = "profile_pic"
        case isFavourite = "favorite"
        case url
    }
    
    init(id: Int!, firstName: String!, lastName: String!, contactImage: String!, isFavourite: Bool!, url: String!) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.contactImage = contactImage
        self.isFavourite = isFavourite
        self.url = url
    }

}
