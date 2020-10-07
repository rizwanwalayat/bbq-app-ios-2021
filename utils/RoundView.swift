//
//  RoundView.swift
//  Aduro
//
//  Created by Macbook Pro on 05/05/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
}
}
