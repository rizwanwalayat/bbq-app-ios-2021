//
//  FormViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 08/10/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit

class FormViewController: UIViewController,UITextFieldDelegate,dropdown {
    func clickCountry(countryName: String) {
        dropdownOutlet.setTitle(countryName, for: .normal)
    }
    

    @IBOutlet weak var dropdownOutlet: UIButton!
    
    @IBOutlet weak var productNumber: UITextField!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var city: UITextField!
    
    
    
    
    @IBOutlet weak var LABEL: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LABEL.attributedText=Language.getInstance().GetForm().htmlToAttributedString
        LABEL.textColor=UIColor.white
//        productNumber.returnKeyType = .done
        
        
        dropdownOutlet.backgroundColor = .white
        dropdownOutlet.layer.cornerRadius = 5
        dropdownOutlet.layer.borderWidth = 0.5
        dropdownOutlet.layer.borderColor = UIColor.lightGray.cgColor
        dropdownOutlet.setTitle("denmark",for: .normal)


        productNumber.placeholder=Language.getInstance().getlangauge(key: "personal_prodno")
        firstname.placeholder=Language.getInstance().getlangauge(key: "personal_name")
        lastname.placeholder=Language.getInstance().getlangauge(key: "personal_lastname")
        address.placeholder=Language.getInstance().getlangauge(key: "personal_addr")
        city.placeholder=Language.getInstance().getlangauge(key: "city")
        email.placeholder=Language.getInstance().getlangauge(key: "personal_email")
        phone.placeholder=Language.getInstance().getlangauge(key: "personal_phone")
        
        
        self.productNumber.delegate=self
        self.firstname.delegate=self
        self.lastname.delegate=self
        self.address.delegate=self
        self.zip.delegate=self
        self.city.delegate=self
        self.email.delegate=self
        self.phone.delegate=self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("true")
//        textField.resignFirstResponder()
        self.view.endEditing(true);
        return false
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//                self.view.endEditing(true);
//    }

    @IBAction func openDropDown(_ sender: Any) {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "CountryDropDownViewController") as?
                  CountryDropDownViewController else { return}
              sVC.modalPresentationStyle = .custom
              sVC.modalTransitionStyle = .crossDissolve
              sVC.delegate=self
              self.present(sVC, animated: true)
    }
 
    @IBAction func save(_ sender: UIButton) {
        checkvalid()
    }
    
    func checkvalid()  {
        var valid=true
        if(productNumber.text!.count == 0 )
        {
            valid=false
            productNumber.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 2, revert: true)
        }
        if(firstname.text!.count == 0 )
        {
            valid=false
            firstname.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 2, revert: true)
        }
        if(lastname.text!.count == 0 )
        {
            valid=false
            lastname.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 2, revert: true)
        }
        if(address.text!.count == 0 )
        {
            valid=false
            address.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 2, revert: true)
        }
        if(zip.text!.count == 0 )
        {
            valid=false
            zip.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 2, revert: true)
        }
        if(city.text!.count == 0 )
        {
            valid=false
            city.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 2, revert: true)
        }
        if(email.text!.count == 0 )
        {
            valid=false
            email.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 2, revert: true)
        }
        if(phone.text!.count == 0 )
        {
            valid=false
            phone.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 2, revert: true)
        }
        if(valid)
               {
                   submitform()
               }
    }
    
    func submitform()  {
        
        let secondString = "&lastname=" + lastname.text! + "&city=" +  city.text! + "&zip=" + zip.text!
        let firstString =  "&phone=" + phone.text!
        let thirdString = "&country=" + dropdownOutlet.titleLabel!.text! + "&email=" + email.text!
        let finalstring = secondString + firstString + thirdString
        let urlstring = "https://aduro.prevas-dev.pw/api/gateway/personal?" + "user=" + ControllerconnectionImpl.getInstance().getController().getSerial() + "&ctrlpassword=" + ControllerconnectionImpl.getInstance().getController().getPassword() + "&addr=" + self.address.text! + "&prodno=" + productNumber.text! + "&name=" + firstname.text! + finalstring
        if let stringencode = urlstring.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        {
            let url = URL(string: stringencode)
            
                  var request = URLRequest(url: url!)
                  request.httpMethod = "GEt"
                  NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {(response, data, error) in
                      guard let data = data else { return }
                      print(String(data: data, encoding: .utf8)!)
                      self.dismiss(animated: true)
                      
                  }
        }
    }
}

extension UITextField {
    func isError(baseColor: CGColor, numberOfShakes shakes: Float, revert: Bool) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "shadowColor")
        animation.fromValue = baseColor
        animation.toValue = UIColor.red.cgColor
        animation.duration = 0.4
        if revert { animation.autoreverses = true } else { animation.autoreverses = false }
        self.layer.add(animation, forKey: "")

        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.07
        shake.repeatCount = shakes
        if revert { shake.autoreverses = true  } else { shake.autoreverses = false }
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(shake, forKey: "position")
    }
}
