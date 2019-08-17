//
//  CustomImageView.swift
//  Contacts
//
//  Created by Rajtharan G on 18/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

class CircularBorderedImageView: UIImageView {
    
    // MARK: - Initialization methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.rounded()
        self.bordered()
    }
    
}
