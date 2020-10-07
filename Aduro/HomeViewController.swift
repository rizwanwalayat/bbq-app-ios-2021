//
//  HomeViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 21/02/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit
import FGRoute
import CoreLocation
import Network
import SystemConfiguration

class HomeViewController: UIViewController,CLLocationManagerDelegate {

    let concurrentQueue = DispatchQueue(label: "Concurrent Queue", attributes: .concurrent)
    let serialQueue = DispatchQueue(label: "serial Queue")

    
    var serial:String!
    var password:String!
    var fromSplash:Bool!
    var locationManager:CLLocationManager!
    var count=0
//    @IBOutlet weak var connectionLabel: UILabel!
//    @IBOutlet weak var f11label: UILabel!
    
    @IBOutlet weak var timeicon: UIButton!
    @IBOutlet weak var flameicon: UIButton!
    @IBOutlet weak var thermoicon: UIButton!
    
    
    @IBOutlet weak var toptext: UILabel!
    @IBOutlet weak var bottomtext: UILabel!
    @IBOutlet weak var bottomimage: UIButton!
    @IBOutlet weak var timertext: UILabel!
    
    
    @IBOutlet weak var smoketemp: UILabel!
    @IBOutlet weak var heatlevel: UILabel!
    @IBOutlet weak var roomtemp: UILabel!
    
    
    @IBOutlet weak var roomtemplayout: UIView!
    @IBOutlet weak var heattemplayout: UIView!
    
    @IBOutlet weak var opensetting: UIImageView!
    @IBOutlet weak var wrench: UIImageView!
    
    @IBOutlet weak var ovn_image: UIImageView!
    
    
    @IBOutlet weak var versionText: UILabel!
    
    
    @IBOutlet weak var roomTempText: UILabel!
    @IBOutlet weak var heatTempText: UILabel!
    @IBOutlet weak var smokeTempText: UILabel!
    @IBOutlet weak var tempIcon: UIImageView!
    
    
//    @IBOutlet weak var f11values: UILabel!
    var timer : Timer!
    var countDownTimermode1 : Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        settext()
      
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTap))
        wrench.addGestureRecognizer(tapgesture)
        wrench.isUserInteractionEnabled=true
        let tapgesture2 = UITapGestureRecognizer(target: self, action: #selector(self.imageTap))
        opensetting.addGestureRecognizer(tapgesture2)
       locationManager=CLLocationManager()
       locationManager.delegate=self
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.versiontap))
        versionText.addGestureRecognizer(tap)
//        getIP()
//        print(Language.getInstance().getlangauge(key: "lng_selectLng"))
        // Do any additional setup after loading the view.
        
        if(fromSplash==true)
        {
        
            Checklocation()
        }
        else
        {
            if(!ControllerconnectionImpl.getInstance().getController().isAccessPoint())
            {
                //                connectionLabel.text="apprelay"
            }else
            {
                //                connectionLabel.text="direct"
            }
               self.concurrentQueue.async(flags : .barrier) {
                self.getF11(setip: false, directfourg: false)
            }
               self.concurrentQueue.async(flags : .barrier) {
                self.getVersion()
            }
            starthandler()

        }
    }
    
    func settext()  {
        heatTempText.text=Language.getInstance().getlangauge(key: "content_heatLvl")
        smokeTempText.text=Language.getInstance().getlangauge(key: "content_smokeTmp")
        roomTempText.text=Language.getInstance().getlangauge(key: "content_roomTmp")
        toptext.text=Language.getInstance().getlangauge(key: "lng_not_connected")
        bottomtext.text=Language.getInstance().getlangauge(key: "lng_trying_reconnect")
    }
    
    @objc func versiontap()
    {
      
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "ServiceMenuViewController") as? ServiceMenuViewController else { return}
        
        sVC.modalPresentationStyle = .fullScreen
        self.present(sVC, animated: true)
    }
    

    
  @objc func imageTap()
    {
//            print("imagepoped")
                 guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController else { return}
        
        sVC.modalPresentationStyle = .fullScreen
                self.present(sVC, animated: true)
//                dismiss(animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopHandler()
    }
    override func viewDidDisappear(_ animated: Bool) {
        stopHandler()
    }

    override func viewDidAppear(_ animated: Bool) {
      if(count > 0)
      {
        print("start handler")
        starthandler()
        concurrentQueue.async(flags:.barrier) {
            self.getF11(setip: false, directfourg: false)
        }
      }else{
        count = count + 1
        }

    }

    func Checklocation() {
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
//                locationManager.requestWhenInUseAuthorization()
                break
            case .authorizedAlways, .authorizedWhenInUse:
//                print("Access")
                checkConnectionType()
                break
            @unknown default:
                fatalError()
            }
        }
        else
        {
            print("not enable")
        }
    }
    
//    @IBAction func openWizard(_ sender: UIButton) {
//         guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "WizardMainViewController") as? WizardMainViewController else { return}
//        self.present(sVC, animated: true)
////        dismiss(animated: true)
//    }
    
    
    func checkConnectionType() {
        if(FGRoute.isWifiConnected())
        {
            let ssid=FGRoute.getSSID()!
            if(ssid.contains("Aduro"))
            {
                print("aduro wifi")
//
                concurrentQueue.async(flags:.barrier) {
                    self.getF11(setip: true, directfourg: false)

                }
                concurrentQueue.async(flags:.barrier) {
                    self.getVersion()
                }
                concurrentQueue.async(flags:.barrier) {
                    self.exchangeKeys()
                }
//                                    self.getVersion()


            }else
            {
                print("non aduro wifi")
//                self.f11label.text="not aduro wifi going for discovery"
                concurrentQueue.async(flags:.barrier) {
                    self.getIP()
                }
//                getIP()
            }
            
        }
        else
        {
//            connectionLabel.text="4G apprelay case"
            concurrentQueue.async(flags:.barrier) {
                               self.getF11(setip: false,directfourg: true)
                           }
            concurrentQueue.async(flags:.barrier) {
                            self.getVersion()
                        }
                        concurrentQueue.async(flags:.barrier) {
                            self.exchangeKeys()
                        }
        }
        
    }
 
    func getIP()
    {
        
        //        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        //        loadingNotification.mode = MBProgressHUDMode.indeterminate
        //        loadingNotification.label.text = "Loading"
        //        loadingNotification.detailsLabel.text = "Getting Controller IP"
        ControllerconnectionImpl.getInstance().getController().setSerial(serial: serial)
        ControllerconnectionImpl.getInstance().getController().setPassword(password: password)
        ControllerconnectionImpl.getInstance().getController().SetIp(ip: "255.255.255.255")
        ControllerconnectionImpl.getInstance().requestDiscovery {
            (ControllerResponseImpl) in
            let values = ControllerResponseImpl.getDiscoveryValues()
            if(values.isEmpty)
            {
                //                apprelay case change the ip of controller to apprelay
//                print("no controller on app relay")
//                self.f11label.text="discovery got not response"
                ControllerconnectionImpl.getInstance().getController().swapToAppRelay()
//                self.connectionLabel.text="apprelay case but wifi not 4G"
                self.concurrentQueue.async(flags:.barrier) {
                    
                    self.getF11(setip: false,directfourg: false)
                }
                self.concurrentQueue.async(flags:.barrier) {
                                   self.getVersion()
                               }
                self.concurrentQueue.async(flags:.barrier){
                    self.exchangeKeys()
                }
                //                self.exchangeKeys()
            }else
            {
                //                normal case change the ip of controller got in response and exchange keys
                print(values[0])
//                self.f11label.text="got discovery"
                ControllerconnectionImpl.getInstance().getController().SetIp(ip: values[0])
//                self.connectionLabel.text="discovery connection"
                self.concurrentQueue.async {
                    
                    self.getF11(setip: false,directfourg: false)
                }
                self.concurrentQueue.async(flags:.barrier) {
                                   self.getVersion()
                               }
                self.concurrentQueue.async {
                    self.exchangeKeys()
                }
//                self.getF11(setip: false,directfourg: false)
                //                self.exchangeKeys()
                
            }
            
        }
    }
    func getF11(setip : Bool,directfourg:Bool)  {
                if(serial==nil)
                    {
                        ControllerconnectionImpl.getInstance().getController().setSerial(serial: Util.GetDefaultsString(key: Constants.serialKey))
                        ControllerconnectionImpl.getInstance().getController().setPassword(password: Util.GetDefaultsString(key: Constants.passwordKey))
                                   
                    }else
                    {
                        ControllerconnectionImpl.getInstance().getController().setSerial(serial: serial)
                        ControllerconnectionImpl.getInstance().getController().setPassword(password:password)
                                   
                    }
                    if(setip)
                    {
                        ControllerconnectionImpl.getInstance().getController().SetIp(ip: Controller.CONTROLLER_DEFAULT_IP)
                                   
                    }
                    if(directfourg)
                    {
                       //            self.f11label.text="direct 4g apprelay"
                        ControllerconnectionImpl.getInstance().getController().swapToAppRelay()
                    }
                           ControllerconnectionImpl.getInstance().requestF11Identified
                                   {
                                       (ControllerResponseImpl) in
                                       if(ControllerResponseImpl.getPayload().contains("nothing"))
                                       {
                                           print(" f11 error")
                       //                    self.f11label.text=" f11 error"
                       //                    self.getF11(setip: setip, directfourg: directfourg)
                                           //                self.showToast(message: "TimeOut Error Try Again")
                                       }
                                       else
                                       {
                       //                    print(map)
                       //                    self.f11values.text=ControllerResponseImpl.getPayload()
                       //                    self.setimage()
                       //                    self.f11label.text="got f11 values"
                                           self.updateValues()
//                                           self.exchangeKeys()
                                       }
                                       
                               }
    
    }
    
    func getVersion()  {
        
            ControllerconnectionImpl.getInstance().requestDiscovery {
                (ControllerResponseImpl) in
//                       print("discovery : " + ControllerResponseImpl.getPayload()+"")}
                
                if(ControllerResponseImpl.getPayload().contains("nothing"))
                                                     {
                                                         print(" discovery error")
                                     //                    self.f11label.text=" f11 error"
                                     //                    self.getF11(setip: setip, directfourg: directfourg)
                                                         //                self.showToast(message: "TimeOut Error Try Again")
                                                     }
else
                                                     {
                                                        self.setVersionText(variable: ControllerResponseImpl)
                                                        //                                                      self.versionText.text=ControllerResponseImpl.getPayload()
                }
                   }
           
       
    }
    func setVersionText(variable:ControllerResponseImpl)  {
        //First get the nsObject by defining as an optional anyObject
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?

        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        
        let slpitstring=variable.getDiscoveryValues()
                                                             
        let finalString = "v"+version+"/"+slpitstring[3]+"."+slpitstring[4]+"/"+slpitstring[1]
        self.versionText.text=finalString
        
        
    }
    func exchangeKeys()
    {
       
        ControllerconnectionImpl.getInstance().requestRead(key: "misc.rsa_key")
        {
            (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                print("error")
            }
            else
            {
                RSAHelper().loadPubKey(key: ControllerResponseImpl.GetReadValueForKeyExchange()["rsa_key"]!)
               self.concurrentQueue.async(flags:.barrier){
                self.setXtea()
                }
            }
        }
    }
    func setXtea()  {
         let xteakey = XTEAHelper().loadKey()
        ControllerconnectionImpl.getInstance().requestSet(key: "misc.xtea_key", value: xteakey, encryptionMode: "*", requestCompletionHandler:
                          {
                              (ControllerResponseImpl) in
                              if(ControllerResponseImpl.getPayload().contains("nothing"))
                              {
                                  print("error")
                                  self.exchangeKeys()
                              }
                              else
                              {
                                  self.starthandler()
                              }
                              
                      })
    }
    func changeSetting(state_super:String,state:String,boiler_timer:String)  {
        if(state_super == "0" && state == "0"
            || ( state_super == "2" && state == "6")
            || ( state_super == "1" && state == "9")
            || ( state_super == "2" && state == "23")
            || ( state_super == "1" && state == "9")
            )
        {
//            startanimation
            startanimation()
        }else
        {
//         stop animation
            stopanimation()
        }
        
        
        if((state_super == "2" && state == "23")  || (state_super == "2" && state == "6"))
        {
            startanimation()
            opensetting.image=UIImage(named: "settings_green")
        }else if (state_super == "0")
        {
            opensetting.image=UIImage(named: "settings_green")

        }else if (state_super == "1")
        {
            if(state == "9" || boiler_timer == "1")
            {
                opensetting.image=UIImage(named: "settings_green")

            }else
            {
                opensetting.image=UIImage(named: "settings_yellow")

            }
            
        }else if (state_super == "2")
        {
            opensetting.image=UIImage(named: "settings_red")

        }
    }
    func startanimation()  {
        UIView.animate(withDuration: 0.7, delay: 0.2, options:[.repeat,.autoreverse], animations: {
            self.opensetting.alpha=0.5
            
        }) { (Bool) in
            self.opensetting.alpha=1
        }
    }
    func stopanimation()  {
        
        UIView.animate(withDuration: 0.7, delay: 0.2, options:[.repeat,.autoreverse], animations: {
//            self.opensetting.alpha=0.5
            
        }) { (Bool) in
            self.opensetting.alpha=1
        }    }
    func updateValues() {
        let stringMap = ControllerconnectionImpl.getInstance().getFrontData()
        if(stringMap.count>0)
        {
         
            
            if(stringMap[IControllerConstants.wirelessSensorStatus] == "0")
            {
                tempIcon.isHidden=true
            }
            else if(stringMap[IControllerConstants.wirelessSensorStatus] == "1")
            {
                tempIcon.isHidden=false
                tempIcon.image=UIImage(named: "whitetemp")
            }
            else if (stringMap[IControllerConstants.wirelessSensorStatus] == "2")
            {
             tempIcon.isHidden=false
                tempIcon.image=UIImage(named: "redtemp")
            }
           
        
        setimage()
            changeSetting(state_super: stringMap[IControllerConstants.stateSuper]!, state: stringMap[IControllerConstants.state]!, boiler_timer: stringMap[IControllerConstants.boilerTemp]!)
        

        //        TopText
        let value=stringMap[IControllerConstants.stateSuper]
        let string=Language.getInstance().getlangauge(key: "super_" + value!)
        if(string.contains("{{name}}"))
        {
            
            let replacestring=string.replacingOccurrences(of: "{{name}}", with: "")
//            toptext.adjustsFontSizeToFitWidth = true
//            toptext.sizeToFit()
            toptext.text=replacestring
        }else
        {
            let key=stringMap[IControllerConstants.stateSuper]
            let newbvalue = "super_" + key!
            toptext.text=Language.getInstance().getlangauge(key: newbvalue);
        }
        
//        bottom text
        bottomtext.text=Language.getInstance().getlangauge(key: "state_" + stringMap[IControllerConstants.state]!)
        //            bottomICON
        if(stringMap[IControllerConstants.state]=="14")
        {
            bottomimage.isHidden=false
        }else
        {
            bottomimage.isHidden=true
        }
        
        //        topicons
        if(stringMap[IControllerConstants.boilerTime] == "1" && stringMap[IControllerConstants.state] != "14")
        {
            timeicon.isHidden=false
        }else
        {
            timeicon.isHidden=true
        }
        if(stringMap[IControllerConstants.operationMode] == "0" && stringMap[IControllerConstants.state] != "9")
        {
            flameicon.isHidden=false
        }else
        {
            flameicon.isHidden=true
        }
        if(stringMap[IControllerConstants.operationMode] == "1" && stringMap[IControllerConstants.state] != "9")
        {
            thermoicon.isHidden=false
        }else
        {
            thermoicon.isHidden=true
        }
        
        
//        smoketemp
        let am=stringMap[IControllerConstants.smokeTemp]
        let temp=Double(am!)
        let rounde=temp?.rounded()
        smoketemp.text=String(Int(rounde!)) + " C°"

        
//        roomtemp
        if(stringMap[IControllerConstants.operationMode] == "1" && stringMap[IControllerConstants.boilerRef] != "" )
        {
            roomtemplayout.isHidden=false
            roomtemp.text=stringMap[IControllerConstants.boilerTemp]! + "(" + stringMap[IControllerConstants.boilerRef]! + ") C°"
        }
        else
        {
            
            roomtemplayout.isHidden=true
        }
        
//        heatLevel
        if(stringMap[IControllerConstants.operationMode] == "0" &&
            heatlevel(string: stringMap[IControllerConstants.regulationFixedPower]!) != 0 )
        {
            heattemplayout.isHidden=false
            heatlevel.text = String(heatlevel(string: stringMap[IControllerConstants.regulationFixedPower]!)) + "("
            + stringMap[IControllerConstants.boilerTemp]! + "C° )"
           
        }
        else
        {
            heattemplayout.isHidden=true
        }
        
        
//        timertext
        let stateSec=stringMap[IControllerConstants.stateSec]
        let finaltemp=Double(stateSec!)
        var finalround=finaltemp?.rounded()
        if(Int(finalround!) > 0)
        {
            
            timertext.isHidden=false
            if(countDownTimermode1 != nil)
                             {
                                 countDownTimermode1!.invalidate()
                                 countDownTimermode1=nil
                     //            print("stop timer")
                             }
             countDownTimermode1 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)
                            { (Timer) in
//                                print("counter 1 chal raha \(Timer)")
                                
                                let seconds = Int(finalround!) % 60
                                let totalMinutes = finalround! / 60
                                let minutes = Int(totalMinutes) % 60;
                                if(minutes<10)
                                {
                                    if(seconds<10)
                                    {
                                        self.timertext.text = "0" + String(minutes) + ":0" + String(seconds)
                                    }else
                                    {
                                        
                                        self.timertext.text = "0" + String(minutes) + ":" + String(seconds)
                                    }
                                }else if (seconds<10)
                                {
                                    self.timertext.text = String(minutes) + ":0" + String(seconds)
                                }else
                                {
                                    self.timertext.text = String(minutes) + ":" + String(seconds)
                                }
                                finalround=finalround!-1
                               
                            }
            RunLoop.current.add(countDownTimermode1, forMode: RunLoop.Mode.common)

        }else
        {
             if(countDownTimermode1 != nil)
                    {
                        countDownTimermode1!.invalidate()
                        countDownTimermode1=nil
            //            print("stop timer")
                    }
            timertext.isHidden=true
        }
            
        }
    
    }
    
    
    func heatlevel(string:String) -> Int {
        
        switch string {
        case "10":
            return 1
        case "50":
            return  2;
        case "100":
            return  3;
        default:
            return  0;
        }
    }
    
    func setimage()
    {
        let map = ControllerconnectionImpl.getInstance().getFrontData()
        if(map.count>0)
        {
            let state=map["state"]
            if(state=="28")
            {
                changeimage(status: "8")
            }else if(state=="0")
            {
                changeimage(status: "4")
            }else
            {
                changeimage(status: map["off_on_alarm"]!)
            }
        }
     
    }
    func changeimage(status:String)
    {
//        ovnStatuses = {
//            default: 'ovn.png',
//            open: 'ovn_open.png',
//            fire: 'ovn_ild.png',
//            wood: 'ovn_ild_pellets.png'
//        };
        
        switch status {
        case "0":
            ovn_image.image=UIImage(named: "ovn.png")
            break
        case "1":
            ovn_image.image=UIImage(named: "ovn_ild.png")
            break
        case "2":
            ovn_image.image=UIImage(named: "ovn.png")
            break
        case "3":
            ovn_image.image=UIImage(named: "ovn.png")
            break
        case "4":
            ovn_image.image=UIImage(named: "ovn_ild.png")
            break
        case "5":
            ovn_image.image=UIImage(named: "ovn.png")
            break
        case "8":
            ovn_image.image=UIImage(named: "ovn_open.png")
            break
        case "9":
            ovn_image.image=UIImage(named: "ovn_ild_pellets.png")
            break
        default:
            ovn_image.image=UIImage(named: "ovn_open.png")
        }
    }
    

    func starthandler()
    {
    
        if(timer == nil)
        {
        
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {
                (Timer) in
                //            print("start timer")
                //            let queue = DispatchQueue(label: "f11")
                //            queue.async {
                self.concurrentQueue.async(flags : .barrier) {
                    ControllerconnectionImpl.getInstance().requestF11Identified { (ControllerResponseImpl) in
                        if(ControllerResponseImpl.getPayload().contains("nothing"))
                        {
                            //                print("error")
                            //                self.showToast(message: "TimeOut Error Try Again")
                            //                    self.f11label.text=" f11 error"
                            
                        }
                        else
                        {
                            //                        DispatchQueue.main.async {
                            //                    self.updatevalues(response: ControllerResponseImpl)
                            //                    self.f11values.text=ControllerResponseImpl.getPayload()
                            //                    self.setimage()
                            //                    self.f11label.text="got f11 values"
                            //                        }
                            self.updateValues()
                        }
                        
                    }
                }
                
                //            }
                
            }
            RunLoop.current.add(timer, forMode: .common)
        }
        
    }
    func stopHandler() {
        
        if(timer != nil)
        {
            timer!.invalidate()
            timer=nil
            print("stop timer")
        }
        if(countDownTimermode1 != nil)
        {
            countDownTimermode1!.invalidate()
            countDownTimermode1=nil
//            print("stop timer")
        }
        
    }
}
