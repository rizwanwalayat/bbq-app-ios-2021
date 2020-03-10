//
//  agreementViewController.swift
//  BBQ
//
//  Created by Macbook Pro on 28/08/2019.
//  Copyright © 2019 Phaedra. All rights reserved.
//

import UIKit

class agreementViewController: UIViewController {
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func decline(_ sender: UIButton)
    {
        let alert = UIAlertController(title: Language.getInstance().getlangauge(key: "initial_tos_decline_popup_title"), message: "", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive, handler: nil))
          self.present(alert, animated: true, completion: nil)
    }
    @IBAction func accept(_ sender: UIButton)
    {
            defaults.set(true, forKey: Constants.term1Accept)
            guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "WizardMainViewController") as? WizardMainViewController else
            {
                return
                
            }
//            let navController = UINavigationController(rootViewController: sVC)
//            navController.navigationBar.barTintColor = UIColor(red: 21.0/255.0, green: 22.0/255.0, blue: 24.0/255.0, alpha: 1.0)
//            navController.navigationBar.barStyle = .black
            self.present(sVC, animated: true)

}
}
