//
//  FormViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 08/10/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit

class FormViewController: UIViewController,UITextFieldDelegate,dropdown,SelectCountryViewControllerDelegate{
    func didSelectCuontry(country: Country) {
        countryCode.text=country.dial_code
        print(country.toJSONString())
        if let url = URL(string: country.image ) {
            
            countryImage.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.1), runImageTransitionIfCached: false, completion: {response in
            })
        }
    }
    
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
    
    
    
    
    @IBOutlet weak var countryCode: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var LABEL: UILabel!
    @IBOutlet weak var btnSaveLabel: RoundButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LABEL.attributedText=Language.getInstance().GetForm().htmlToAttributedString
        LABEL.textColor=UIColor.white
//        productNumber.returnKeyType = .done
        let timtabletap = UITapGestureRecognizer(target: self, action: #selector(self.timetap(_:)))
        let timtabletap1 = UITapGestureRecognizer(target: self, action: #selector(self.timetap1(_:)))

        countryCode.isUserInteractionEnabled=true
        countryCode.addGestureRecognizer(timtabletap1)
        countryImage.addGestureRecognizer(timtabletap)
        
        dropdownOutlet.backgroundColor = .white
        dropdownOutlet.layer.cornerRadius = 5
        dropdownOutlet.layer.borderWidth = 0.5
        dropdownOutlet.layer.borderColor = UIColor.lightGray.cgColor
        dropdownOutlet.setTitle("Denmark",for: .normal)


        productNumber.placeholder=Language.getInstance().getlangauge(key: "personal_prodno")
        firstname.placeholder=Language.getInstance().getlangauge(key: "personal_name")
        lastname.placeholder=Language.getInstance().getlangauge(key: "personal_lastname")
        address.placeholder=Language.getInstance().getlangauge(key: "personal_addr")
        city.placeholder=Language.getInstance().getlangauge(key: "city")
        email.placeholder=Language.getInstance().getlangauge(key: "personal_email")
        phone.placeholder=Language.getInstance().getlangauge(key: "personal_phone")
        btnSaveLabel.setTitle(Language.getInstance().getlangauge(key: "personal_submit"), for: .normal)
        
        self.productNumber.delegate=self
        self.firstname.delegate=self
        self.lastname.delegate=self
        self.address.delegate=self
        self.zip.delegate=self
        self.city.delegate=self
        self.email.delegate=self
        self.phone.delegate=self
        countryCode.text="+45"
        countryImage.af_setImage(withURL: URL(string: "https://www.countryflags.io/DK/flat/64.png")!, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.1), runImageTransitionIfCached: false, completion: {response in
        })

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
    @objc func timetap(_ sender:UITapGestureRecognizer)
     {
        let Vc = SelectCountryViewController()
               Vc.delegate = self
               self.present(Vc, animated: true, completion: nil)
     }
    @objc func timetap1(_ sender:UITapGestureRecognizer)
     {
        let Vc = SelectCountryViewController()
               Vc.delegate = self
               self.present(Vc, animated: true, completion: nil)
     }
    @IBAction func openDropDown(_ sender: Any) {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "CountryDropDownViewController") as?
                  CountryDropDownViewController else { return}
              sVC.modalPresentationStyle = .custom
              sVC.modalTransitionStyle = .crossDissolve
              sVC.delegate=self
              self.present(sVC, animated: true)
    }
 
    @IBAction func save(_ sender: UIButton) {
//        let Vc = SelectCountryViewController()
//        Vc.delegate = self
//        self.present(Vc, animated: true, completion: nil)
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
        let firstString =  "&phone=" + countryCode.text! + phone.text!
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
extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
