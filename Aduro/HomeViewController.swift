//
//  HomeViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 21/02/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit
import SwiftyJSON
import FGRoute
import CoreLocation
import Network
import SystemConfiguration

class HomeViewController: UIViewController,CLLocationManagerDelegate {

    var serial:String!
    var password:String!
    var fromSplash:Bool!
    var locationManager:CLLocationManager!
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet weak var f11label: UILabel!
    @IBOutlet weak var ovn_image: UIImageView!
    
    @IBOutlet weak var f11values: UILabel!
    var timer : Timer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
       locationManager=CLLocationManager()
       locationManager.delegate=self
//        getIP()
//        print(Language.getInstance().getlangauge(key: "lng_selectLng"))
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopHandler()
    }

    override func viewDidAppear(_ animated: Bool) {
        if(fromSplash==true)
        {
            Checklocation()
        }
        else
        {
            if(!ControllerconnectionImpl.getInstance().getController().isAccessPoint())
            {
                connectionLabel.text="apprelay"
            }else
            {
                connectionLabel.text="direct"
            }
            getF11(setip: false, directfourg: false)
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
            }
        }
        else
        {
            print("not enable")
        }
    }
    
    @IBAction func openWizard(_ sender: UIButton) {
         guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "WizardMainViewController") as? WizardMainViewController else { return}
        self.present(sVC, animated: true)
//        dismiss(animated: true)
    }
    
    
    func checkConnectionType() {
        if(FGRoute.isWifiConnected())
        {
            var ssid=FGRoute.getSSID()!
            if(ssid.contains("Aduro"))
            {
//                let serialQueue = DispatchQueue(label: "SerialQueue")
                print("aduro wifi")
                self.f11label.text="direct  connection"
                connectionLabel.text="aduro wifi"
//                serialQueue.sync {
                    getF11(setip: true,directfourg: false)
//                }
//                serialQueue.sync {
//                    exchangeKeys()
//
//                }
            }else
            {
                print("non aduro wifi")
                self.f11label.text="not aduro wifi going for discovery"
                getIP()
            }
            
        }
        else
        {
            connectionLabel.text="4G apprelay case"
            self.getF11(setip: false,directfourg: true)
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
                self.f11label.text="discovery got not response"
                ControllerconnectionImpl.getInstance().getController().swapToAppRelay()
                self.connectionLabel.text="apprelay case but wifi not 4G"
                self.getF11(setip: false,directfourg: false)
                //                self.exchangeKeys()
            }else
            {
                //                normal case change the ip of controller got in response and exchange keys
                print(values[0])
                self.f11label.text="got discovery"
                ControllerconnectionImpl.getInstance().getController().SetIp(ip: values[0])
                self.connectionLabel.text="discovery connection"

                self.getF11(setip: false,directfourg: false)
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
            ControllerconnectionImpl.getInstance().getController().setPassword(password: password)
            
        }
       if(setip)
        {
            ControllerconnectionImpl.getInstance().getController().SetIp(ip: Controller.CONTROLLER_DEFAULT_IP)
            
        }
        if(directfourg)
        {
            self.f11label.text="direct 4g apprelay"
            ControllerconnectionImpl.getInstance().getController().swapToAppRelay()
        }
        ControllerconnectionImpl.getInstance().requestF11Identified
            {
                (ControllerResponseImpl) in
                if(ControllerResponseImpl.getPayload().contains("nothing"))
                {
                    print("error")
                    self.f11label.text=" f11 error"
//                    self.getF11(setip: setip, directfourg: directfourg)
                    //                self.showToast(message: "TimeOut Error Try Again")
                }
                else
                {
//                    print(map)
                    self.f11values.text=ControllerResponseImpl.getPayload()
//                    self.setimage()
                    self.f11label.text="got f11 values"
                    self.exchangeKeys()
                }
                
        }
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
                RSAHelper().loadPubKey(key: ControllerResponseImpl.GetReadValue()["rsa_key"]!)
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
        }
    }
    func setimage()
    {
        let map = ControllerconnectionImpl.getInstance().getFrontData()
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
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {
            (Timer) in
            //            print("start timer")
            //            let queue = DispatchQueue(label: "f11")
            //            queue.async {
            ControllerconnectionImpl.getInstance().requestF11Identified { (ControllerResponseImpl) in
                if(ControllerResponseImpl.getPayload().contains("nothing"))
                {
                    //                print("error")
                    //                self.showToast(message: "TimeOut Error Try Again")
                    self.f11label.text=" f11 error"

                }
                else
                {
                    //                        DispatchQueue.main.async {
//                    self.updatevalues(response: ControllerResponseImpl)
                    self.f11values.text=ControllerResponseImpl.getPayload()
                    //                    self.setimage()
                    self.f11label.text="got f11 values"
                    //                        }
                }
                
            }
            //            }
            
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    func stopHandler() {
        
        if(timer != nil)
        {
            timer!.invalidate()
            print("stop timer")
        }
        
    }
}
