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
    
    class func appBlackColor(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 74.0 / 255.0, green: 74.0 / 255.0 , blue: 74.0 / 255.0, alpha: alpha)
    }
    
    class func menuGreenColor(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 80.0 / 255.0, green: 227.0 / 255.0 , blue: 194.0 / 255.0, alpha: alpha)
    }
    
}

extension UIBarButtonItem {
    
    func applyTintColor(color: UIColor) {
        self.tintColor = color
    }
    
}

extension UIView {
    
    func rounded() {
        self.layer.cornerRadius = self.bounds.size.width / 2.0
        self.clipsToBounds = true
    }
    
    func bordered() {
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.cgColor
    }
    
}

var vSpinner : UIView?

extension UIViewController {
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        let ai = UIActivityIndicatorView.init(style: .gray)
        ai.startAnimating()
        ai.center = spinnerView.center
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        vSpinner?.removeFromSuperview()
        vSpinner = nil
    }
    
}
