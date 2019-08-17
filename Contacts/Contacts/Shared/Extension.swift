//
//  Extension.swift
//  Contacts
//
//  Created by Rajtharan G on 17/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import Foundation
import UIKit

extension Contact {
    
    func fullName() -> String {
        if let firstName = self.firstName, let lastname = self.lastName {
            return "\(firstName) \(lastname)"
        }
        return self.firstName ?? ""
    }
    
}

extension UIImageView {
    
    func load(urlString: String?) {
        if let urlString = urlString, let url = URL(string: urlString) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                } else {
                    // Load placeholder
                }
            }
        } else {
            // Load placeholder
        }
    }
    
}
