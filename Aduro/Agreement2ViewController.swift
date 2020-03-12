//
//  Agreement2ViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 10/03/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit

class Agreement2ViewController: UIViewController {
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func decline(_ sender: UIButton) {
        let alert = UIAlertController(title: Language.getInstance().getlangauge(key: "initial_tos_decline_popup_title"), message: "", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (UIAlertAction) in
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func accept(_ sender: UIButton) {
        defaults.set(true, forKey: Constants.term2Accept)
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "setupWifiControllerViewController") as? setupWifiControllerViewController else
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
