//
//  RoundButton.swift
//  Aduro
//
//  Created by Macbook Pro on 13/04/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import Foundation


import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var gradientcolour: UIColor = UIColor.clear{
        didSet{
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [borderColor.cgColor, UIColor.white.cgColor]
        self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
