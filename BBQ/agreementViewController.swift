//
//  agreementViewController.swift
//  BBQ
//
//  Created by Macbook Pro on 28/08/2019.
//  Copyright © 2019 Phaedra. All rights reserved.
//

import UIKit

class agreementViewController: UIViewController{
    let defaults = UserDefaults.standard

    @IBOutlet weak var termTitleLbl: UILabel!
    @IBOutlet weak var acceptbtn: UIButton!
    @IBOutlet weak var declinebtn: UIButton!
    
    @IBOutlet weak var gradient: gradient!
    @IBOutlet weak var textAgreement: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        acceptbtn.layer.cornerRadius = 10
//        acceptbtn.clipsToBounds = true
        self.gradient.installGradientwithvounds(frame: self.view.bounds)
        self.gradient.updateGradient(frame: self.view.bounds)

        termTitleLbl.text = Language.getInstance().getlangauge(key: "terms_title")
        textAgreement.attributedText=Language.getInstance().getFirstTerm().htmlToAttributedString
        textAgreement.textColor=UIColor.white
        declinebtn.setTitle(Language.getInstance().getlangauge(key: "decline"), for: .normal)
        acceptbtn.setTitle(Language.getInstance().getlangauge(key: "accept"), for: .normal)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {

    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

        sVC.modalPresentationStyle = .fullScreen
//            let navController = UINavigationController(rootViewController: sVC)
//            navController.navigationBar.barTintColor = UIColor(red: 21.0/255.0, green: 22.0/255.0, blue: 24.0/255.0, alpha: 1.0)
//            navController.navigationBar.barStyle = .black
            self.present(sVC, animated: true)

}
}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
