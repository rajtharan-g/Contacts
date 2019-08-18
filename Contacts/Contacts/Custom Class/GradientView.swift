//
//  GradientView.swift
//  Contacts
//
//  Created by Rajtharan G on 18/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

class GradientView: UIView {

    var gradientLayer: CAGradientLayer?
    
    // MARK: - Initialization methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
    
    // MARK: - Custom methods
    
    func applyGradient() {
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = self.bounds
        gradientLayer?.colors = [UIColor.white.cgColor, UIColor.menuGreenColor(alpha: 0.28).cgColor]
        gradientLayer?.opacity = 0.55
        if let topLayer = self.layer.sublayers?.first, topLayer is CAGradientLayer {
            topLayer.removeFromSuperlayer()
        }
        if let gradientLayer = gradientLayer {
            self.layer.addSublayer(gradientLayer)
        }
    }


}
