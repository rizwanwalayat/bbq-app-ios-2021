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
    var fromsetting:Bool=false

    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        if(fromsetting)
        {
           

        }else
        {
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
                    sVC.modalPresentationStyle = .fullScreen
                    self.present(sVC, animated: true)
                    //                print("show wizard")
                }
                
            }
        }
       
//        else
//        {
//            print("do nothing")
//        }
    }
    func loadmain(serial:String,password:String)  {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return}
        sVC.serial=serial
        sVC.password=password
        sVC.fromSplash=true
        
        sVC.modalPresentationStyle = .fullScreen
//        let parentvs=self.presentingViewController
//        self.dismiss(animated: true) {
//            parentvs!.present(sVC, animated: true)
//        }
        self.present(sVC, animated: true)

       
        //        self.dismiss(animated: true)
    }
    
    func justlangaugechange(serial:String,password:String)  {
              guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return}
                sVC.serial=serial
                sVC.password=password
                sVC.fromSplash=true
                sVC.justlangChange=true
                sVC.modalPresentationStyle = .fullScreen
//                let parentvs=self.presentingViewController
        //        self.dismiss(animated: true) {
        //            parentvs!.present(sVC, animated: true)
        //        }
                self.present(sVC, animated: true)

    }
    
    @IBAction func english(_ sender: Any) {
        defaults.set("en", forKey: Constants.languageKey)
        Language.getInstance().readjson(fileName: "en")
        Language.getInstance().ReadTerm(fileName: "en")
        Language.getInstance().ReadTerm2(fileName: "en")
        if(fromsetting)
        {
            let serial=defaults.string(forKey: Constants.serialKey)
            let password=defaults.string(forKey: Constants.passwordKey)
            justlangaugechange(serial: serial!, password: password!)
            
        }else
        {
            guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "agreementViewController") as? agreementViewController else
            {
                return
                
            }
            
            sVC.modalPresentationStyle = .fullScreen
            self.present(sVC, animated: true)
            
        }
    }
    @IBAction func danish(_ sender: Any) {
        defaults.set("da", forKey: Constants.languageKey)
        Language.getInstance().readjson(fileName: "da")
        Language.getInstance().ReadTerm(fileName: "dk")
        Language.getInstance().ReadTerm2(fileName: "dk")
        if(fromsetting)
              {
                  let serial=defaults.string(forKey: Constants.serialKey)
                             let password=defaults.string(forKey: Constants.passwordKey)
                             justlangaugechange(serial: serial!, password: password!)
                  
              }else
              {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "agreementViewController") as? agreementViewController else
        {
            return
            
        }
        
        sVC.modalPresentationStyle = .fullScreen
        self.present(sVC, animated: true)
        }
    }
    
    @IBAction func spain(_ sender: Any) {
        defaults.set("es", forKey: Constants.languageKey)
        Language.getInstance().readjson(fileName: "es")
        Language.getInstance().ReadTerm(fileName: "es")
        Language.getInstance().ReadTerm2(fileName: "es")
        if(fromsetting)
              {
                  let serial=defaults.string(forKey: Constants.serialKey)
                             let password=defaults.string(forKey: Constants.passwordKey)
                             justlangaugechange(serial: serial!, password: password!)
                  
              }else
              {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "agreementViewController") as? agreementViewController else
        {
            return
            
        }
        
        sVC.modalPresentationStyle = .fullScreen
        self.present(sVC, animated: true)
        }
    }
    
    @IBAction func france(_ sender: UIButton) {
        defaults.set("fr", forKey: Constants.languageKey)
        Language.getInstance().readjson(fileName: "fr")
        Language.getInstance().ReadTerm(fileName: "fr")
        Language.getInstance().ReadTerm2(fileName: "fr")
        if(fromsetting)
              {
                  let serial=defaults.string(forKey: Constants.serialKey)
                             let password=defaults.string(forKey: Constants.passwordKey)
                             justlangaugechange(serial: serial!, password: password!)
                  
              }else
              {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "agreementViewController") as? agreementViewController else
        {
            return
            
        }
        
        sVC.modalPresentationStyle = .fullScreen
        self.present(sVC, animated: true)
        }
    }
    @IBAction func dutch(_ sender: UIButton) {
           defaults.set("du", forKey: Constants.languageKey)
           Language.getInstance().readjson(fileName: "du")
           Language.getInstance().ReadTerm(fileName: "du")
           Language.getInstance().ReadTerm2(fileName: "du")
           if(fromsetting)
                 {
                     let serial=defaults.string(forKey: Constants.serialKey)
                                let password=defaults.string(forKey: Constants.passwordKey)
                                justlangaugechange(serial: serial!, password: password!)
                     
                 }else
                 {
           guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "agreementViewController") as? agreementViewController else
           {
               return
               
           }
           
           sVC.modalPresentationStyle = .fullScreen
           self.present(sVC, animated: true)
           }
       }
    @IBAction func sweden(_ sender: UIButton) {
           defaults.set("sw", forKey: Constants.languageKey)
           Language.getInstance().readjson(fileName: "sw")
           Language.getInstance().ReadTerm(fileName: "sw")
           Language.getInstance().ReadTerm2(fileName: "sw")
           if(fromsetting)
                 {
                     let serial=defaults.string(forKey: Constants.serialKey)
                                let password=defaults.string(forKey: Constants.passwordKey)
                                justlangaugechange(serial: serial!, password: password!)
                     
                 }else
                 {
           guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "agreementViewController") as? agreementViewController else
           {
               return
               
           }
           
           sVC.modalPresentationStyle = .fullScreen
           self.present(sVC, animated: true)
           }
       }
    
    
    
    
    
    @IBAction func German(_ sender: UIButton) {
        defaults.set("ge", forKey: Constants.languageKey)
        Language.getInstance().readjson(fileName: "ge")
        Language.getInstance().ReadTerm(fileName: "en")
        Language.getInstance().ReadTerm2(fileName: "en")
        if(fromsetting)
              {
                  let serial=defaults.string(forKey: Constants.serialKey)
                             let password=defaults.string(forKey: Constants.passwordKey)
                             justlangaugechange(serial: serial!, password: password!)
                  
              }else
              {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "agreementViewController") as? agreementViewController else
        {
            return
            
        }
        
        sVC.modalPresentationStyle = .fullScreen
        self.present(sVC, animated: true)
        }
    }
    
    @IBAction func ukrain(_ sender: UIButton) {
        defaults.set("ua", forKey: Constants.languageKey)
        Language.getInstance().readjson(fileName: "ua")
        Language.getInstance().ReadTerm(fileName: "en")
        Language.getInstance().ReadTerm2(fileName: "en")
        if(fromsetting)
              {
                  let serial=defaults.string(forKey: Constants.serialKey)
                             let password=defaults.string(forKey: Constants.passwordKey)
                             justlangaugechange(serial: serial!, password: password!)
                  
              }else
              {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "agreementViewController") as? agreementViewController else
        {
            return
            
        }
        
        sVC.modalPresentationStyle = .fullScreen
        self.present(sVC, animated: true)
        }
    }
    @IBAction func italy(_ sender: UIButton) {
        defaults.set("it", forKey: Constants.languageKey)
        Language.getInstance().readjson(fileName: "it")
        Language.getInstance().ReadTerm(fileName: "it")
        Language.getInstance().ReadTerm2(fileName: "it")
        if(fromsetting)
              {
                  let serial=defaults.string(forKey: Constants.serialKey)
                             let password=defaults.string(forKey: Constants.passwordKey)
                             justlangaugechange(serial: serial!, password: password!)
                  
              }else
              {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "agreementViewController") as? agreementViewController else
        {
            return
            
        }
        
        sVC.modalPresentationStyle = .fullScreen
        self.present(sVC, animated: true)
        }
    }
    @IBAction func russia(_ sender: UIButton) {
        defaults.set("ru", forKey: Constants.languageKey)
        Language.getInstance().readjson(fileName: "ru")
        Language.getInstance().ReadTerm(fileName: "en")
        Language.getInstance().ReadTerm2(fileName: "en")
        if(fromsetting)
              {
                  let serial=defaults.string(forKey: Constants.serialKey)
                             let password=defaults.string(forKey: Constants.passwordKey)
                             justlangaugechange(serial: serial!, password: password!)
                  
              }else
              {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "agreementViewController") as? agreementViewController else
        {
            return
            
        }
        
        sVC.modalPresentationStyle = .fullScreen
        self.present(sVC, animated: true)
        }
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
