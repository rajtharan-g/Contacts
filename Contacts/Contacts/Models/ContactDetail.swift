//
//  ContactDetail.swift
//  Contacts
//
//  Created by Rajtharan G on 17/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

class ContactDetail: Contact {
    
    var email: String? = nil
    var phone: String?
    var createdAt: String?
    var updatedAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case email
        case phone = "phone_number"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decode(String?.self, forKey: .email)
        self.phone = try container.decode(String?.self, forKey: .phone)
        self.createdAt = try container.decode(String?.self, forKey: .createdAt)
        self.updatedAt = try container.decode(String?.self, forKey: .updatedAt)
        try super.init(from: decoder)
    }
    
    override init(id: Int!, firstName: String!, lastName: String!, contactImage: String!, isFavourite: Bool!, url: String!) {
        super.init(id: id, firstName: firstName, lastName: lastName, contactImage: contactImage, isFavourite: isFavourite, url: url)
    }

}
