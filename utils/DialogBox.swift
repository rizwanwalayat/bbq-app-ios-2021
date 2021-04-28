//
//  DialogBox.swift
//  BBQ
//
//  Created by ps on 15/04/2021.
//  Copyright © 2021 nbe. All rights reserved.
//

import UIKit

class DialogBox: UIViewController {

    var titleText: String = ""
    var descriptionText: String = ""
    var okBtnText: String = "OK"
    @IBOutlet private weak var shortTitle: UILabel!
    @IBOutlet private weak var longDescription: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shortTitle.text = titleText
        longDescription.text = descriptionText
        okBtn.setTitle(okBtnText, for: .normal)
    }
    
    func configure(titleText: String, descriptionText: String, okBtnText: String){
        self.titleText = titleText
        self.descriptionText = descriptionText
        self.okBtnText = okBtnText
    }
    
    @IBAction func OKBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
