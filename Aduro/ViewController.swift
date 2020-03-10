//
//  ViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 21/02/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import Network
//import MBProgressHUD



class ViewController: UIViewController {
    let defaults = UserDefaults.standard
    @IBOutlet weak var serialText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var directRadio: UISwitch!
    @IBOutlet weak var setupwifiBTN: UIButton!
    @IBOutlet weak var withoutstepBTN: UIButton!
    @IBOutlet weak var connectwarningtext: UILabel!
    @IBOutlet weak var serialbtntitle: UIButton!
    @IBOutlet weak var resultbtntitle: UIButton!
    @IBOutlet weak var serialView: UIView!
    @IBOutlet weak var resultView: UIView!
    
    
    @IBOutlet weak var wizard_2_description: UILabel!
    @IBOutlet weak var wizard_2_subtitle_1: UILabel!
    @IBOutlet weak var wizard_2_subtitle_2: UILabel!
    @IBOutlet weak var wizard_2_subtitle_3: UILabel!
    @IBOutlet weak var wizard_2_subtitle_3_success: UILabel!
    @IBOutlet weak var wizard_2_subtitle_3_success2: UILabel!
    @IBOutlet weak var wifi_connect_current: UILabel!
    @IBOutlet weak var wizard_2_dont_wifi_button: UIButton!
    
    @IBOutlet weak var first_time_connect_check_box: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wizard_2_description.text=Language.getInstance().getlangauge(key: "wizard_2_description")
        wizard_2_subtitle_1.text=Language.getInstance().getlangauge(key: "wizard_2_subtitle_1")
        wizard_2_subtitle_2.text=Language.getInstance().getlangauge(key: "wizard_2_subtitle_2")
        
        wizard_2_subtitle_3.text=Language.getInstance().getlangauge(key: "wizard_2_subtitle_3")
        wizard_2_subtitle_3_success.text=Language.getInstance().getlangauge(key: "wizard_2_subtitle_3_success")
        wizard_2_subtitle_3_success2.text=Language.getInstance().getlangauge(key: "wizard_2_subtitle_3_success2")
        
        wifi_connect_current.text=Language.getInstance().getlangauge(key: "wifi_connect_current")
        
        withoutstepBTN.setTitle(Language.getInstance().getlangauge(key: "wizard_2_wifi_button_use_existing"), for: .normal)
        
        
        setupwifiBTN.setTitle(Language.getInstance().getlangauge(key: "wizard_2_wifi_button"), for: .normal)
        
        wizard_2_dont_wifi_button.setTitle(Language.getInstance().getlangauge(key: "wizard_2_dont_wifi_button"), for: .normal)
        
        first_time_connect_check_box.text=Language.getInstance().getlangauge(key: "first_time_connect_check_box")
        
        
        serialText.text = "38043"
        passwordText.text = "9267673412"
        resultView.isHidden=true
        resultbtntitle.setTitle("+", for: .normal)
        serialbtntitle.setTitle("-", for: .normal)
        serialText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        getWiFiSsid()
        // Do any additional setup after loading the view.
    }
@objc func textFieldDidChange(_ sender: UIView) {
//    print("text change \(serialText.text)")
//    print("get password of serial in defaults \(defaults.string(forKey: serialText.text!))")
    if(defaults.string(forKey: serialText.text!)==nil)
    {
        print("no password")
    }else
    {
        passwordText.text=defaults.string(forKey: serialText.text!)
    }
    }
    
    
    @IBAction func setupwifi(_ sender: Any) {
        
    }
    
    
    @IBAction func serialbtn(_ sender: Any) {
        if(serialView.isHidden)
        {
            
            serialView.isHidden = false
            serialbtntitle.setTitle("-", for: .normal)
            serialView.layoutIfNeeded()
            if(!resultView.isHidden)
            {
                resultView.isHidden = true
                resultbtntitle.setTitle("+", for: .normal)
            }
            //            let viewHeight:CGFloat = 100
            //            serialView.visiblity(gone: false, dimension: viewHeight)
        }else
        {
            serialView.isHidden = true
            serialbtntitle.setTitle("+", for: .normal)
            serialView.layoutIfNeeded()
            //            let viewHeight:CGFloat = 0.0
            //            serialView.visiblity(gone: true, dimension: viewHeight)
        }
    }
    
    @IBAction func resultbtn(_ sender: Any) {
        if(resultView.isHidden)
        {
            resultView.isHidden = false
            resultbtntitle.setTitle("-", for: .normal)
            if(!serialView.isHidden)
            {
                serialView.isHidden = true
                serialbtntitle.setTitle("+", for: .normal)
            }
            resultView.layoutIfNeeded()
            //            let viewHeight:CGFloat = 100
            //            serialView.visiblity(gone: false, dimension: viewHeight)
        }else
        {
            resultView.isHidden = true
            resultbtntitle.setTitle("+", for: .normal)
            resultView.layoutIfNeeded()
            //            let viewHeight:CGFloat = 0.0
            //            serialView.visiblity(gone: true, dimension: viewHeight)
        }
    }
    
    @IBAction func btnconnect(_ sender: Any) {
        if (directRadio.isOn)
        {
            directConnect()
        }else
        {
            getIP()
        }
    }
    func directConnect()
    {
        ControllerconnectionImpl.getInstance().getController().setSerial(serial: serialText.text!)
        ControllerconnectionImpl.getInstance().getController().setPassword(password: passwordText.text!)
        ControllerconnectionImpl.getInstance().getController().SetIp(ip: Controller.CONTROLLER_DEFAULT_IP)
        
        //        var socket = insocket()
        //        socket.setupConnection(payload: "misc.rsa_key", payloadlength: "012")
        //        ControllerconnectionImpl.getInstance().requestRead(key: "misc.rsa_key")
        exchangeKeys()
    }
    
    
    func exchangeKeys()
    {
//        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
//        loadingNotification.mode = MBProgressHUDMode.indeterminate
//        loadingNotification.label.text = "Loading"
//        loadingNotification.detailsLabel.text = "Connecting"
        ControllerconnectionImpl.getInstance().requestRead(key: "misc.rsa_key")
        {
            (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                print("error")
                self.showToast(message: "TimeOut Error Try Again")
//                loadingNotification.hide(animated: true)
            }
            else
            {
                //            print(ControllerResponseImpl.GetReadValue()["rsa_key"]!)
                RSAHelper().loadPubKey(key: ControllerResponseImpl.GetReadValue()["rsa_key"]!)
                let xteakey = XTEAHelper().loadKey()
                //                let loadingNotification1 = MBProgressHUD.showAdded(to: self.view, animated: true)
                //                loadingNotification1.hide(animated: true)
                //                loadingNotification1.mode = MBProgressHUDMode.indeterminate
                
                
//                loadingNotification.label.text = "Loading"
//                loadingNotification.detailsLabel.text = "Exchanging Keys"
                ControllerconnectionImpl.getInstance().requestSet(key: "misc.xtea_key", value: xteakey, encryptionMode: "*", requestCompletionHandler:
                    {
                        (ControllerResponseImpl) in
                        if(ControllerResponseImpl.getPayload().contains("nothing"))
                        {
                            print("error")
                            self.showToast(message: "TimeOut Error Try Again")
//                            loadingNotification.hide(animated: true)
                        }
                        else
                        {
//                            loadingNotification.hide(animated: true)
                            self.showToast(message: "Keys Exchange Done")
                            
                            if(ControllerconnectionImpl.getInstance().getController().isAccessPoint())
                            {
                                self.checkControllerConnectedToWifi()
                                if(!self.serialView.isHidden)
                                {
                                    self.serialView.isHidden=true
                                    self.resultView.isHidden=false
                                }
                            }else
                            {
                                self.showToast(message: "Move To Main")
                                self.defaults.set(self.passwordText.text, forKey: self.serialText.text!)
                                guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return}
//                                self.navigationController?.pushViewController(sVC, animated: true)
//                                self.dismiss(animated: true)
                                self.defaults.set(self.serialText.text, forKey: Constants.serialKey)
                                self.defaults.set(self.passwordText.text, forKey: Constants.passwordKey)
                                sVC.serial=self.serialText.text!
                                sVC.password=self.passwordText.text!
                                sVC.fromSplash=false
                                self.present(sVC, animated: true, completion: {
                                    
                                })
                            }
                            
                        }
                        
                })
            }
        }
    }
    
    
    
    
    
    func checkControllerConnectedToWifi()
    {
        ControllerconnectionImpl.getInstance().requestRead(key: "wifi.router")
        {
            (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                //                print("error")
                //                self.showToast(message: "TimeOut Error Try Again")
                self.checkControllerConnectedToWifi()
            }
            else
            {
                let string = ControllerResponseImpl.GetReadValue()["router"]
                let item = string?.split(separator: ",")
                let s : String = String(item![1])
                if(s != "2")
                {
                    self.connectwarningtext.isHidden=false
                    self.withoutstepBTN.isHidden=true
                    self.setupwifiBTN.backgroundColor = UIColor(red: 61/255, green: 203/255, blue: 100/255, alpha: 1.0)
                    self.setupwifiBTN.setTitleColor(.white, for: .normal)
                    self.wifi_connect_current.text="Current network : "
                }
                else
                {
                    self.connectwarningtext.isHidden=true
                    self.withoutstepBTN.isHidden=false
                    self.setupwifiBTN.backgroundColor = UIColor.white
                    self.setupwifiBTN.setTitleColor(.black, for: .normal)
                    self.wifi_connect_current.text="Current network : " + String(item![0])
                }
            }
            
            
        }
    }
    
    
    
    @IBAction func useExistingWifiBtn(_ sender: UIButton) {
        self.defaults.set(self.passwordText.text, forKey: self.serialText.text!)
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return}
        //                                self.navigationController?.pushViewController(sVC, animated: true)
        //                                self.dismiss(animated: true)
        self.defaults.set(self.serialText.text, forKey: Constants.serialKey)
        self.defaults.set(self.passwordText.text, forKey: Constants.passwordKey)
        sVC.serial=self.serialText.text!
        sVC.password=self.passwordText.text!
        sVC.fromSplash=false
        self.present(sVC, animated: true, completion: {
            
        })
    }

    func getIP()
    {
//        defaults.string(forKey: "serial")!
//        defaults.string(forKey: "password")!
        
//        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
//        loadingNotification.mode = MBProgressHUDMode.indeterminate
//        loadingNotification.label.text = "Loading"
//        loadingNotification.detailsLabel.text = "Getting Controller IP"
        ControllerconnectionImpl.getInstance().getController().setSerial(serial: serialText.text! )
        ControllerconnectionImpl.getInstance().getController().setPassword(password: passwordText.text!)
        ControllerconnectionImpl.getInstance().getController().SetIp(ip: "255.255.255.255")
        ControllerconnectionImpl.getInstance().requestDiscovery {
            (ControllerResponseImpl) in
            let values = ControllerResponseImpl.getDiscoveryValues()
            if(values.isEmpty)
            {
                //                apprelay case change the ip of controller to apprelay
                print("no controller go app relay")
                ControllerconnectionImpl.getInstance().getController().swapToAppRelay()
//                self.getF11(setip: false)
                self.exchangeKeys()
            }else
            {
                //                normal case change the ip of controller got in response and exchange keys
                print(values[0])
                ControllerconnectionImpl.getInstance().getController().SetIp(ip: values[0])
//                self.getF11(setip: false)
                self.exchangeKeys()
                
            }
            
        }
    }


    
    
}


extension ViewController: UITextViewDelegate
{
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}
