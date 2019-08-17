//
//  ContactDetail.swift
//  Contacts
//
//  Created by Rajtharan G on 17/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

class ContactDetail: Codable {
    
    let id: Int?
    let firstName: String?
    let lastName: String?
    let contactImage: String?
    var isFavourite: Bool?
    let email: String?
    let phone: String?
    var createdAt: String?
    var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case contactImage = "profile_pic"
        case isFavourite = "favorite"
        case email
        case phone = "phone_number"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

}
