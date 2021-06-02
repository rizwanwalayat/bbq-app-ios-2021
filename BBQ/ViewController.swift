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
import MBProgressHUD
import FGRoute

import AVFoundation

class ViewController: UIViewController,UITextFieldDelegate {
 
    let concurrentQueue = DispatchQueue(label: "view Queue", attributes: .concurrent)

    let defaults = UserDefaults.standard
    @IBOutlet weak var connectButton: RoundButton!
    @IBOutlet weak var torch: UIImageView!
    var currentWifi=""

    @IBOutlet weak var serialText: DropDown!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var directRadio: UISwitch!
    @IBOutlet weak var setupwifiBTN: UIButton!
    @IBOutlet weak var withoutstepBTN: UIButton!
    @IBOutlet weak var connectwarningtext: UILabel!
    @IBOutlet weak var serialbtntitle: UIButton!
    @IBOutlet weak var resultbtntitle: UIButton!
    @IBOutlet weak var serialView: UIView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var connectionView: UIView!
    
    
    @IBOutlet weak var wizard_2_description: UILabel!
    @IBOutlet weak var wizard_2_subtitle_1: UILabel!
    @IBOutlet weak var wizard_2_subtitle_2: UILabel!
    @IBOutlet weak var wizard_2_subtitle_3: UILabel!
    @IBOutlet weak var wizard_2_subtitle_3_success: UILabel!
    @IBOutlet weak var wizard_2_subtitle_3_success2: UILabel!
    @IBOutlet weak var wifi_connect_current: UILabel!
    @IBOutlet weak var wizard_2_dont_wifi_button: UIButton!
    
    @IBOutlet weak var first_time_connect_check_box: UILabel!
    
    @IBOutlet weak var btncontinueOutlet: UIButton!
    
    @IBOutlet weak var directConnectionAlert: UILabel!
    
    @IBOutlet weak var gradient: gradient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gradient.installGradientwithvounds(frame: self.view.bounds)
        self.gradient.updateGradient(frame: self.view.bounds)

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
             
             let notificationCenter1 = NotificationCenter.default
        notificationCenter1.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTap))
        torch.addGestureRecognizer(tapgesture)
        torch.isUserInteractionEnabled=true

        setupToHideKeyboardOnTapOnView()
        
        
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
        directConnectionAlert.text=Language.getInstance().getlangauge(key: "wizard_2_subtitle_2_description")
        btncontinueOutlet.setTitle(Language.getInstance().getlangauge(key: "wizard_2_button"), for: .normal)
        connectButton.setTitle(Language.getInstance().getlangauge(key: "wizard_2_subtitle_2_button"), for: .normal)
        
        btncontinueOutlet.setBackgroundColor(#colorLiteral(red: 0.9808368087, green: 0.6705261469, blue: 0.6306552887, alpha: 1), for: .highlighted)
        
//        serialText.text = "38043"
//        passwordText.text = "9267673412"
        let serialvalue=Util.GetDefaultsString(key: Constants.serialKey)
        let passwordvalue=Util.GetDefaultsString(key: Constants.passwordKey)
        if(serialvalue != "nothing")
        {

            serialText.text = serialvalue
        }
        if(passwordvalue != "nothing")
        {
            passwordText.text = passwordvalue
        }
        
        PasswordCheck()
//        PasswordtextFieldDidChange(self.view)
        resultView.isHidden=true
        resultbtntitle.setTitle("+", for: .normal)
        serialbtntitle.setTitle("-", for: .normal)
        connectionView.isHidden=true
//        serialText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        passwordText.addTarget(self, action: #selector(PasswordtextFieldDidChange(_:)), for: .editingChanged)
        serialText.returnKeyType=UIReturnKeyType.next
        passwordText.returnKeyType=UIReturnKeyType.done
        serialText.delegate = self
        passwordText.delegate = self

        if(defaults.bool(forKey: Constants.secondtime))
        {
            defaults.set(true, forKey: Constants.secondtime)
            directRadio.isOn=false
        }
        else
        {
            
            defaults.set(true, forKey: Constants.secondtime)
            directRadio.isOn=true
        }
     

        showdropdown()

    }
    var list : [Util.ControllerList]!
    func showdropdown()  {
        do
        {
            list =  try Util.GetController()
            var temp = [String]()
            for item in list
            {
                temp.append(item.serial)
            }
           
                serialText.optionArray = temp
                serialText.textColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                serialText.font = UIFont.systemFont(ofSize: 14)
                serialText.didSelect { (String, Index, Id) in
                    print(String)
                    self.serialText.text=String
                    self.passwordText.text = self.list[Index].password
                }
            
    //            serialText.showList()
            

        }catch
        {
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {

    }
  
    @objc func imageTap()
        {
            toggleFlashlight()
            
        }
    
       /// toggles the device's flashlight, if possible
       func toggleFlashlight() {
            guard let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch else { return }
            do {
                try device.lockForConfiguration()
                let torchOn = !device.isTorchActive
                try device.setTorchModeOn(level: 1.0)
                device.torchMode = torchOn ? .on : .off
                if(torchOn)
                {
                    
                    self.torch.image=#imageLiteral(resourceName: "torch_on")
                }else
                {
                    self.torch.image=#imageLiteral(resourceName: "torch_of")
                }
                device.unlockForConfiguration()
            } catch {
                print("Error toggling Flashlight: \(error)")
            }
        }
    @objc func appMovedToForeground() {
        print("App moved to ForeGround!")
        connectButton.backgroundColor = .systemRed

    }
    @objc func appMovedToBackground() {
        print("App moved to Background!")
    }
//    var countofscreenappear = 0
//    override func viewDidAppear(_ animated: Bool) {
//        if(countofscreenappear > 0)
//        {
//            connectButton.backgroundColor=UIColor(named: "green")
//        }
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        countofscreenappear=countofscreenappear+1
//    }
   
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.donepassword))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        passwordText.inputAccessoryView = doneToolbar
    }
    @objc func donepassword()  {

    }
    
    //MARK: UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextTF = textField.superview?.viewWithTag(nextTag) {
            nextTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true

//        print("true")
//        textField.resignFirstResponder()
//        self.view.endEditing(true)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.tag == 1){
//            serialText.showList()
        }
//        print("change found")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        view.endEditing(true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 1 {
            if(defaults.string(forKey: serialText.text!)==nil)
            {
                print("no password")
            }else
            {
                passwordText.text=defaults.string(forKey: serialText.text!)
            }
        }
            
            PasswordCheck()
        
    }
    
    func PasswordCheck() {
        if(serialText.text?.count==5 && passwordText.text?.count==10)
        {
            passwordText.resignFirstResponder()
            serialText.resignFirstResponder()
            view.endEditing(true)

            btncontinueOutlet.isEnabled=true
            btncontinueOutlet.isUserInteractionEnabled=true
            btncontinueOutlet.backgroundColor = .systemRed
        }else
        {
            btncontinueOutlet.isEnabled=false
            btncontinueOutlet.backgroundColor=UIColor(red: 47.0/255.0, green: 47.0/255.0, blue: 49.0/255.0, alpha: 1.0)
        }
    }
    
    
//    @objc func textFieldDidChange(_ sender: UIView) {
//    //    print("text change \(serialText.text)")
//    //    print("get password of serial in defaults \(defaults.string(forKey: serialText.text!))")
//        if(defaults.string(forKey: serialText.text!)==nil)
//        {
//            print("no password")
//        }else
//        {
//            passwordText.text=defaults.string(forKey: serialText.text!)
//        }
//        
////        if(serialText.text?.count==5){
////            serialText.resignFirstResponder()
////            passwordText.becomeFirstResponder()
////        }
//        
//    }
//    
//    @objc func PasswordtextFieldDidChange(_ sender: UIView) {
//        if(passwordText.text?.count==10)
//        {
//            passwordText.resignFirstResponder()
//            btncontinueOutlet.isEnabled=true
//            btncontinueOutlet.isUserInteractionEnabled=true
//            btncontinueOutlet.backgroundColor = .systemRed
//        }else
//        {
//            btncontinueOutlet.isEnabled=false
//            btncontinueOutlet.backgroundColor=UIColor(red: 47.0/255.0, green: 47.0/255.0, blue: 49.0/255.0, alpha: 1.0)
//        }
//    }
    
    
    @IBAction func setupwifi(_ sender: Any) {
        let showterm=defaults.bool(forKey: Constants.term2Accept)
        self.defaults.set(self.serialText.text, forKey: Constants.serialKey)
        self.defaults.set(self.passwordText.text, forKey: Constants.passwordKey)
        if(showterm==true)
        {
            guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "setupWifiControllerViewController") as? setupWifiControllerViewController else { return}
            sVC.modalPresentationStyle = .fullScreen
            sVC.currentnetworkvale=currentWifi
            self.present(sVC, animated: true)
            print("show wifi setting")

        }else
        {
            guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "Agreement2ViewController") as? Agreement2ViewController else { return}
            sVC.modalPresentationStyle = .fullScreen
            self.present(sVC, animated: true)
                        print("show term")
        }
        
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
            if(!connectionView.isHidden)
            {
                connectionView.isHidden=true
            }
            //            let viewHeight:CGFloat = 100
            //            serialView.visiblity(gone: false, dimension: viewHeight)
        }else
        {
            serialView.isHidden = true
            serialbtntitle.setTitle("+", for: .normal)
            serialView.layoutIfNeeded()
            if(!connectionView.isHidden)
            {
                connectionView.isHidden=true
            }
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
            if(!connectionView.isHidden)
            {
                connectionView.isHidden=true
            }
            //            let viewHeight:CGFloat = 100
            //            serialView.visiblity(gone: false, dimension: viewHeight)
        }else
        {
            resultView.isHidden = true
            resultbtntitle.setTitle("+", for: .normal)
            resultView.layoutIfNeeded()
            if(!connectionView.isHidden)
            {
                connectionView.isHidden=true
            }
            //            let viewHeight:CGFloat = 0.0
            //            serialView.visiblity(gone: true, dimension: viewHeight)
        }
    }
    
    @IBAction func btnconnect(_ sender: Any) {
        if(serialText.text! == "12345"){
            ControllerconnectionImpl.getInstance().getController().setSerial(serial: serialText.text!)
            ControllerconnectionImpl.getInstance().getController().setPassword(password: passwordText.text!)
            ControllerconnectionImpl.getInstance().getController().SetIp(ip: Controller.CONTROLLER_DEFAULT_IP)
            self.defaults.set(self.passwordText.text, forKey: self.serialText.text!)
            self.defaults.set(self.serialText.text, forKey: Constants.serialKey)
            self.defaults.set(self.passwordText.text, forKey: Constants.passwordKey)
            if(ControllerconnectionImpl.getInstance().getController().isAccessPoint())
            {
                setupwifiBTN.isHidden=true
                if(!self.serialView.isHidden)
                {
                    self.serialView.isHidden=true
                    self.resultView.isHidden=false
                }
                if(!self.connectionView.isHidden)
                {
                    self.serialView.isHidden=true
                    self.connectionView.isHidden=true
                    self.resultView.isHidden=false
                }
            }else
            {

                self.concurrentQueue.async(flags:.barrier) {
                    self.checkControllerConnectedToWifi()
                             }
                if(!self.serialView.isHidden)
                {
                    self.serialView.isHidden=true
                    self.resultView.isHidden=false
                }
                if(!self.connectionView.isHidden)
                {
                    self.serialView.isHidden=true
                    self.connectionView.isHidden=true
                    self.resultView.isHidden=false
                }
            }
        }else
        {

             let ssid=FGRoute.getSSID()
            passwordText.resignFirstResponder()
             serialText.resignFirstResponder()
             if (directRadio.isOn){
                
                withoutstepBTN.setTitle(Language.getInstance().getlangauge(key: "direct_connection"), for: .normal)
                
                if((ssid?.starts(with: "BBQ-"))!)
                 {
                     Util.SetDefaultsBool(key: Constants.directConnectFlag, value: true)
                     directConnect()
                 }else
                 {
                     let replace = Language.getInstance().getlangauge(key: "wizard_2_subtitle_2_description").replacingOccurrences(of: "{{serial}}", with: serialText.text!)
                     directConnectionAlert.text=replace
                     serialView.isHidden = true
                     serialbtntitle.setTitle("+", for: .normal)
                     connectionView.isHidden=false
                 }
               
             }else
             {
                withoutstepBTN.setTitle(Language.getInstance().getlangauge(key: "wizard_2_wifi_button_use_existing"), for: .normal)
                
                concurrentQueue.async(flags:.barrier) {
                                                 self.getIP()
                                             }
//                 if(isVPNConnected())
//                 {
//                     print("no controller go app relay")
//                     ControllerconnectionImpl.getInstance().getController().setSerial(serial: self.serialText.text! )
//                     ControllerconnectionImpl.getInstance().getController().setPassword(password: self.passwordText.text!)
//                     ControllerconnectionImpl.getInstance().getController().swapToAppRelay()
//                                     self.concurrentQueue.async(flags:.barrier) {
//                                         self.exchangeKeys()
//                     //                    self.getIP()
//                                     }
//                 }
//                 else
//                 {
//
//                 }
               
             }
        }
      
    }
    func isVPNConnected() -> Bool {
        let cfDict = CFNetworkCopySystemProxySettings()
        let nsDict = cfDict!.takeRetainedValue() as NSDictionary
        if(nsDict["_SCOPED__"] != nil)
        {
            let keys = nsDict["__SCOPED__"] as! NSDictionary

            for key: String in keys.allKeys as! [String] {
                if (key == "tap" || key == "tun" || key == "ppp" || key == "ipsec" || key == "ipsec0" || key == "utun1" || key == "utun2") {
                    return true
                }
            }
        }else
        {
            return false
        }
        return false
    }
    
    @IBAction func ConnectBtnSecond(_ sender: UIButton) {
        let ssid=FGRoute.getSSID()!
        
        if (directRadio.isOn)
        {
//            if(ssid.starts(with: "Aduro-"))
            if(ssid.starts(with: "BBQ-"))

            {
                Util.SetDefaultsBool(key: Constants.directConnectFlag, value: true)
                directConnect()
            }else
            {
                 let replace = Language.getInstance().getlangauge(key: "wizard_2_subtitle_2_description").replacingOccurrences(of: "{{serial}}", with: serialText.text!)
                directConnectionAlert.text=replace
                serialView.isHidden = true
                serialbtntitle.setTitle("+", for: .normal)
                connectionView.isHidden=false
            }
            
        }else
        {
            concurrentQueue.async(flags:.barrier) {
                                                  self.getIP()
                                              }
//            if(isVPNConnected())
//                      {
//                          print("no controller go app relay")
//                          ControllerconnectionImpl.getInstance().getController().setSerial(serial: self.serialText.text! )
//                          ControllerconnectionImpl.getInstance().getController().setPassword(password: self.passwordText.text!)
//                          ControllerconnectionImpl.getInstance().getController().swapToAppRelay()
//                                          self.concurrentQueue.async(flags:.barrier) {
//                                              self.exchangeKeys()
//                          //                    self.getIP()
//                                          }
//                      }
//                      else
//                      {
//
//                      }
            
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
          concurrentQueue.async(flags:.barrier) {
            self.exchangeKeys()
        }
    }
    
    
    func exchangeKeys()
    {
        var loadingNotification : MBProgressHUD!
        
        DispatchQueue.main.async {
             loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = Language.getInstance().getlangauge(key: "loading")
            loadingNotification.detailsLabel.text = Language.getInstance().getlangauge(key:"connecting")
        }
        ControllerconnectionImpl.getInstance().requestRead(key: "misc.rsa_key")
        {
            (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                print("error")
                DispatchQueue.main.async {
                    self.showToast(message: "Timeout Error Try Again")
                    loadingNotification.hide(animated: true)
                   }
            }
            else
            {
                //            print(ControllerResponseImpl.GetReadValue()["rsa_key"]!)
//                RSAHelper().loadPubKey(key: ControllerResponseImpl.GetReadValueForKeyExchange()["rsa_key"]!)
                //                let loadingNotification1 = MBProgressHUD.showAdded(to: self.view, animated: true)
                //                loadingNotification1.hide(animated: true)
                //                loadingNotification1.mode = MBProgressHUDMode.indeterminate
                if let val = ControllerResponseImpl.GetReadValueForKeyExchange()["rsa_key"]
                              {
                                   RSAHelper().loadPubKey(key: val)
                                  self.concurrentQueue.async(flags:.barrier){
                                   self.concurrentQueue.async(flags:.barrier) {
                                                 self.setXtea(loadingNotification: loadingNotification)
                                             }
                                    
                                }
                              }else
                              {
                                  print("wrong response")
                                DispatchQueue.main.async {
                                    loadingNotification.hide(animated: true)
                                }

                              }
          
                
         
            }
        }
    }
    
    
    
    func setXtea(loadingNotification:MBProgressHUD)  {
        let xteakey = XTEAHelper().loadKey()

             DispatchQueue.main.async {
                        loadingNotification.label.text = Language.getInstance().getlangauge(key: "loading")
                                      loadingNotification.detailsLabel.text = Language.getInstance().getlangauge(key:"connecting")
                    }
                  
                    ControllerconnectionImpl.getInstance().requestSet(key: "misc.xtea_key", value: xteakey, encryptionMode: "*", requestCompletionHandler:
                        {
                            (ControllerResponseImpl) in
                            if(ControllerResponseImpl.getPayload().contains("nothing"))
                            {
                                print("error")
                                self.showToast(message: "Timeout Error Try Again")
                                loadingNotification.hide(animated: true)
                            }
                            else
                            {
                                
                                DispatchQueue.main.async {
                                    loadingNotification.hide(animated: true)
                                    self.saveControllerListToPreferences()
                                }
//                                self.showToast(message: "Keys Exchange Done")
                                self.defaults.set(self.passwordText.text, forKey: self.serialText.text!)
                                self.defaults.set(self.serialText.text, forKey: Constants.serialKey)
                                self.defaults.set(self.passwordText.text, forKey: Constants.passwordKey)
                                if(ControllerconnectionImpl.getInstance().getController().isAccessPoint())
                                {
                                    self.concurrentQueue.async(flags:.barrier) {

                                        self.checkControllerConnectedToWifi()
                                                    }
                                    if(!self.serialView.isHidden)
                                    {
                                        self.serialView.isHidden=true
                                        self.resultView.isHidden=false
                                    }
                                    if(!self.connectionView.isHidden)
                                    {
                                        self.serialView.isHidden=true
                                        self.connectionView.isHidden=true
                                        self.resultView.isHidden=false
                                    }
                                }else
                                {

                                    self.concurrentQueue.async(flags:.barrier) {
                                        self.checkControllerConnectedToWifi()
                                                 }
                                    if(!self.serialView.isHidden)
                                    {
                                        self.serialView.isHidden=true
                                        self.resultView.isHidden=false
                                    }
                                    if(!self.connectionView.isHidden)
                                    {
                                        self.serialView.isHidden=true
                                        self.connectionView.isHidden=true
                                        self.resultView.isHidden=false
                                    }
                                }
                                
                            }
                            
                    })
      }
    func saveControllerListToPreferences()  {
        do
        {
            var list = try Util.GetController()
            var controller = Util.ControllerList(serial: ControllerconnectionImpl.getInstance().getController().getSerial(), password: ControllerconnectionImpl.getInstance().getController().getPassword())
            
            if(list.isEmpty)
            {
                list.append(controller)
            }else
            {
                var found = false
                var serail = ControllerconnectionImpl.getInstance().getController().getSerial()
                for item in list
                {
                    if(serail == item.serial)
                    {
                        found = true
                    }
                }
                if(!found)
                {
                   list.append(controller)
                }
            }
             try Util.SaveController(value: list)
        
        }catch
        {
        print("catch")
        }

    }
    func checkControllerConnectedToWifi()
    {
        ControllerconnectionImpl.getInstance().requestRead(key: "wifi.router")
        {
            (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
               
            }
            else
            {
                let routerResponse = ControllerResponseImpl.GetReadValue()["router"]
                
                if(routerResponse != nil)
                {
                    let items = routerResponse?.split(separator: ",")
                    let string : String = String(items![0])
                    if(string == "")
                    {
                        self.connectwarningtext.isHidden=false
                        self.withoutstepBTN.isHidden=true
                        self.setupwifiBTN.backgroundColor = UIColor(red: 61/255, green: 203/255, blue: 100/255, alpha: 1.0)
                        self.setupwifiBTN.setTitleColor(.white, for: .normal)
                        self.wifi_connect_current.text=Language.getInstance().getlangauge(key: "wifi_connect_current")+": "
                    }
                    else
                    {
                        self.connectwarningtext.isHidden=true
                        self.withoutstepBTN.isHidden=false
                        self.setupwifiBTN.backgroundColor = UIColor.white
                        self.setupwifiBTN.setTitleColor(.black, for: .normal)
                        self.currentWifi=string
                        self.wifi_connect_current.text=Language.getInstance().getlangauge(key: "wifi_connect_current")+" : " + string
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func useExistingWifiBtn(_ sender: UIButton) {
        self.defaults.set(self.passwordText.text, forKey: self.serialText.text!)
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return}
//        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return}
        //                                self.navigationController?.pushViewController(sVC, animated: true)
        //                                self.dismiss(animated: true)
        self.defaults.set(self.serialText.text, forKey: Constants.serialKey)
        self.defaults.set(self.passwordText.text, forKey: Constants.passwordKey)
        sVC.serial=self.serialText.text!
        sVC.password=self.passwordText.text!
        sVC.fromSplash=false
        sVC.modalPresentationStyle = .fullScreen
        self.present(sVC, animated: true, completion: {
            
        })
    }
    
    @IBAction func DoNotUserInternet(_ sender: UIButton) {
//        removeWifi();
    }
    func removeWifi()  {
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
        loadingNotification.detailsLabel.text = "Removing Wifi"
        ControllerconnectionImpl.getInstance().reuqestSetWithoutEncrypt(key: "wifi.router", value: ",")
        { (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                print("error")
                loadingNotification.hide(animated: true)
            }
            else
            {
                loadingNotification.hide(animated: true)
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
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getIP()
    {
//        defaults.string(forKey: "serial")!
//        defaults.string(forKey: "password")!
        var loadingNotification : MBProgressHUD!
        DispatchQueue.main.async {
             loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = Language.getInstance().getlangauge(key: "loading")
            loadingNotification.detailsLabel.text = Language.getInstance().getlangauge(key: "getip")
            ControllerconnectionImpl.getInstance().getController().setSerial(serial: self.serialText.text! )
            ControllerconnectionImpl.getInstance().getController().setPassword(password: self.passwordText.text!)
               ControllerconnectionImpl.getInstance().getController().SetIp(ip: "255.255.255.255")
        }
   
        ControllerconnectionImpl.getInstance().requestDiscovery {
            (ControllerResponseImpl) in
            let values = ControllerResponseImpl.getDiscoveryValues()
            if(values.isEmpty)
            {
                //                apprelay case change the ip of controller to apprelay
                print("no controller go app relay")
                ControllerconnectionImpl.getInstance().getController().swapToAppRelay()
//                self.getF11(setip: false)
                DispatchQueue.main.async {
                    loadingNotification.hide(animated: true)
                }

                self.concurrentQueue.async(flags:.barrier) {

                    self.exchangeKeys()
//                    self.getIP()
                }
            }else
            {
                //                normal case change the ip of controller got in response and exchange keys
                print(values[0])
                ControllerconnectionImpl.getInstance().getController().SetIp(ip: values[0])
//                self.getF11(setip: false)
                DispatchQueue.main.async {
                    loadingNotification.hide(animated: true)
                }
                self.concurrentQueue.async(flags:.barrier) {

                                    self.exchangeKeys()
                //                    self.getIP()
                                }
            }
            
        }
    }

    
    
}

extension ViewController
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

extension UIViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
      }
}
