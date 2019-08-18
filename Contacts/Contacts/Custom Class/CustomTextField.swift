//
//  CustomBlackTextField.swift
//  Contacts
//
//  Created by Rajtharan G on 18/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

class CustomBlackTextField: UITextField {

    // MARK: - Initialization methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyUICustomization()
    }
    
    // MARK: - Custom methods
    
    func applyUICustomization() {
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.textColor = UIColor.appBlackColor()
    }

}
