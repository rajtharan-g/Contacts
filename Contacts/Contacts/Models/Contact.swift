//
//  Contact.swift
//  Contacts
//
//  Created by Rajtharan G on 17/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

class Contact: Decodable {
    
    let id: Int?
    let firstName: String?
    let lastName: String?
    let contactImage: String?
    let isFavourite: Bool?
    let url: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case contactImage = "profile_pic"
        case isFavourite = "favorite"
        case url
    }

}
