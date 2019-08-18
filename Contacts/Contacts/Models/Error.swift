//
//  Error.swift
//  Contacts
//
//  Created by Rajtharan G on 18/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

class ValidationError: Decodable {
    
    var errors: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case errors
    }

}
