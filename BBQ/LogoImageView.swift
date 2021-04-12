//
//  LogoImageView.swift
//  BBQ
//
//  Created by ps on 26/03/2021.
//  Copyright © 2021 nbe. All rights reserved.
//

import UIKit

class LogoImageView: UIImageView {
    override func draw(_ rect: CGRect) {
        self.image = UIImage(named: "logo_small.png")
    }
}
