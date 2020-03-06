//
//  MyCustomView.swift
//  BBQ
//
//  Created by Macbook Pro on 20/08/2019.
//  Copyright © 2019 Phaedra. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
class MyCustomView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}
