//
//  MinMaxDialougeViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 30/07/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit

class MinMaxDialougeViewController: UIViewController {

    @IBOutlet weak var minMaxLabel: UILabel!
    @IBOutlet weak var textfield: UITextField!
    
    var minimunValue:String!
    var maximumValue:String!
    var payload:String!
    var CurrentValue:String!
   
    static let identifier = "PopUpActionViewController"
    var delegate: PopUpDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        //adding an overlay to the view to give focus to the dialog box
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        //customizing the dialog box view
//        dialogBoxView.layer.cornerRadius = 6.0
//        dialogBoxView.layer.borderWidth = 1.2
//        dialogBoxView.layer.borderColor = UIColor(named: “dialogBoxGray”)?.cgColor
        //customizing the go to app store button
      
        textfield.addTarget(self, action: #selector(textFieldTyping), for: .editingChanged)


        // Do any additional setup after loading the view.
        minMaxLabel.text="min: " + minimunValue + ", max: " + maximumValue
        if let range = CurrentValue.range(of: #"\d+(\.\d*)?"#, options: .regularExpression)
        {
            let result = CurrentValue[range]
            print(result)
            textfield.text=String(result)

        }else
        {
                    textfield.text=CurrentValue
        }
    }
    
    @objc func textFieldTyping(textField:UITextField)
    {
        print(textfield.text)
        //Typing
    }
    @IBAction func save(_ sender: UIButton) {
        self.delegate?.handleAction(payloadKEy: payload, value: textfield.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    static func showPopup(parentVC: UIViewController){
//        //creating a reference for the dialogView controller
//        if let popupViewController = self.storyboard?.instantiateViewController(withIdentifier: "MinMaxDialougeViewController") as? MinMaxDialougeViewController {
//            popupViewController.modalPresentationStyle = .custom
//            popupViewController.modalTransitionStyle = .crossDissolve
//            //setting the delegate of the dialog box to the parent viewController
//            popupViewController.delegate = parentVC as? PopUpDelegate
//            //presenting the pop up viewController from the parent viewController
//            parentVC.present(popupViewController, animated: true)
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol PopUpDelegate {
    func handleAction(payloadKEy: String,value:String)
}

