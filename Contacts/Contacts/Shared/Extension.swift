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
                    DispatchQueue.main.async {
                        self?.applyPlaceholder()
                    }
                }
            }
        } else {
            applyPlaceholder()
        }
    }
    
    func applyPlaceholder() {
        self.image = UIImage(named: "placeholder_photo")
    }
    
}

extension UIColor {
    
    class func lightGray() -> UIColor {
        return UIColor(red: 232.0 / 255.0, green: 232.0 / 255.0 , blue: 232.0 / 255.0, alpha: 1.0)
    }
    
    class func veryLightGray() -> UIColor {
        return UIColor(red: 240.0 / 255.0, green: 240.0 / 255.0 , blue: 240.0 / 255.0, alpha: 1.0)
    }
    
    class func appBlackColor() -> UIColor {
        return UIColor(red: 74.0 / 255.0, green: 74.0 / 255.0 , blue: 74.0 / 255.0, alpha: 1.0)
    }
    
    class func menuGreenColor() -> UIColor {
        return UIColor(red: 80.0 / 255.0, green: 227.0 / 255.0 , blue: 194.0 / 255.0, alpha: 1.0)
    }
    
}

extension UIBarButtonItem {
    
    func applyTintColor(color: UIColor) {
        self.tintColor = color
    }
    
}

extension UIImageView {
    
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
}
