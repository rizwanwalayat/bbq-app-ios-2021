//
//  DialogBox.swift
//  BBQ
//
//  Created by ps on 15/04/2021.
//  Copyright © 2021 nbe. All rights reserved.
//

import UIKit

class ConfirmDialogBox: UIViewController {

    var titleText: String = ""
    var descriptionText: String = ""
    var cancelText: String = ""
    var confirmText: String = ""
    var confirmFunction:(()->Void)? = nil
    @IBOutlet private weak var shortTitle: UILabel!
    @IBOutlet private weak var longDescription: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shortTitle.text = titleText
        longDescription.text = descriptionText
        cancelBtn.setTitle(cancelText, for: .normal)
        confirmBtn.setTitle(confirmText, for: .normal)
    }
    
    func configure(titleText: String, descriptionText: String, cancelText: String, confirmText: String, onConfirmClick:(()->Void)? ){
        self.titleText = titleText
        self.descriptionText = descriptionText
        self.cancelText = cancelText
        self.confirmText = confirmText
        confirmFunction = onConfirmClick
    }
    
    @IBAction func CancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func confirmBtnPressed(_ sender: Any) {
        confirmFunction!()
    }
}
