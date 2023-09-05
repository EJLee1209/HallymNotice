//
//  UIColor+Extension.swift
//  Pokedex
//
//  Created by 이은재 on 2023/08/31.
//

import UIKit

extension UIView {
    
    func addShadow(offset: CGSize, color: UIColor, shadowRadius: CGFloat, opacity: Float, cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius

        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = opacity
        
        layer.masksToBounds = false
    }
    
    func addCornerRadius(radius: CGFloat) {
        layer.masksToBounds = false
        layer.cornerRadius = radius
    }
    
    func addRoundedCorners(corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [corners]
    }
    
    func addGradientLayer(colors: [CGColor]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.locations = [0.0, 1.15]
        gradientLayer.colors = colors
//        self.layer.addSublayer(gradientLayer)
        self.layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
    
    func setCornerRadius(gradientLayer: CAGradientLayer, radius: CGFloat, corners: CACornerMask) {
        gradientLayer.cornerRadius = radius
        gradientLayer.maskedCorners = corners
    }
    
}
