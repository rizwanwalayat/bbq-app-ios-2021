//
//  WizardMainViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 24/02/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit

class WizardMainViewController: UIViewController {
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var wizard_1_title: UILabel!
    @IBOutlet weak var wizard_1_description: UILabel!
    @IBOutlet weak var wizard_1_description2: UILabel!
    @IBOutlet weak var wizard_1_description3: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        wizard_1_title.text=Language.getInstance().getlangauge(key: "wizard_1_title")
        wizard_1_description.text="A.  "+Language.getInstance().getlangauge(key: "wizard_1_description")
        wizard_1_description2.text="B.  "+Language.getInstance().getlangauge(key: "wizard_1_description2")
        wizard_1_description3.text="C.  "+Language.getInstance().getlangauge(key: "wizard_1_description3")

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let serial=defaults.string(forKey: Constants.serialKey)
        let password=defaults.string(forKey: Constants.passwordKey)
        if(serial != nil)
        {
            loadmain(serial: serial!, password: password!)
        }else
        {
            
        }
    }
    func loadmain(serial:String,password:String)  {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return}
        sVC.serial=serial
        sVC.password=password
        sVC.fromSplash=true
        self.present(sVC, animated: true)
//        self.dismiss(animated: true)
    }
    
}
