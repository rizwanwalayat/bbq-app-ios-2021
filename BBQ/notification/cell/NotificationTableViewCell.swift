//
//  NotificationTableViewCell.swift
//  Aduro
//
//  Created by Macbook Pro on 09/02/2021.
//  Copyright © 2021 nbe. All rights reserved.
//

import UIKit
import ExpandableLabel

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var dateTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
