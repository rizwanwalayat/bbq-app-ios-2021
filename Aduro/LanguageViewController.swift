//
//  LanguageViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 09/03/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit

class LanguageViewController: UIViewController {
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let langSelected=defaults.bool(forKey: Constants.term1Accept)
        if(langSelected==true)
        {
            let serial=defaults.string(forKey: Constants.serialKey)
            let password=defaults.string(forKey: Constants.passwordKey)
            if(serial != nil)
            {
                loadmain(serial: serial!, password: password!)
            }else
            {
                guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "WizardMainViewController") as? WizardMainViewController else
                {
                    return
                    
                }
                self.present(sVC, animated: true)
                print("show wizard")
            }
            
        }
        else
        {
            print("do nothing")
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
    
    @IBAction func english(_ sender: Any) {
        defaults.set("en", forKey: Constants.languageKey)
        Language.getInstance().readjson(fileName: "en")
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "agreementViewController") as? agreementViewController else
        {
            return
            
        }
        self.present(sVC, animated: true)
    }
    @IBAction func danish(_ sender: Any) {
        defaults.set("da", forKey: Constants.languageKey)
        Language.getInstance().readjson(fileName: "da")
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "agreementViewController") as? agreementViewController else
        {
            return
            
        }
        self.present(sVC, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
