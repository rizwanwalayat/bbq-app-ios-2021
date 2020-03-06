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
    override func viewDidLoad() {
        super.viewDidLoad()

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
