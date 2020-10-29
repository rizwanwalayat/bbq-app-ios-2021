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
import MBProgressHUD

class HomeViewController: UIViewController,CLLocationManagerDelegate,firmwaredelegate {
    func donedialogStartFirmware() {
//        print("done clicked")
            self.stopHandler()
            self.startfirmware()
    }
    

    var classvar=0;
    let concurrentQueue = DispatchQueue(label: "Concurrent Queue", attributes: .concurrent)
    let serialQueue = DispatchQueue(label: "serial Queue")

    
    var serial:String!
    var password:String!
    var fromSplash:Bool!
    var justlangChange:Bool = false
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
    var controller : Controller!
    override func viewDidLoad() {
        super.viewDidLoad()
        settext()
        createNewUIProgressView()
        createCustomImageViews()
        addSubViews()
        
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
        
            if(justlangChange)
            {
                concurrentQueue.async(flags:.barrier)
                {
                    self.getf11()
                }
                concurrentQueue.async(flags:.barrier)
                {
                    self.getVersion()
                }
                starthandler()
             
            }else
            {
                Checklocation()
            }
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

                controller = Controller(serial: serial)
                controller.setPassword(password: password)
                ControllerconnectionImpl.getInstance().setController(controller: controller)
                ControllerconnectionImpl.getInstance().getController().swapToLocal()
                print("aduro wifi")
                ControllerconnectionImpl.getInstance().getController().swapToLocal()
                concurrentQueue.async(flags:.barrier) {
                    self.getF11(setip: true, directfourg: false)

                }
                concurrentQueue.async(flags:.barrier) {
                    self.getVersion()
                }
                concurrentQueue.async(flags:.barrier) {
                    self.exchangeKeys()
                }
                starthandler()
//                                    self.getVersion()


            }else
            {
                print("non aduro wifi")
//                self.f11label.text="not aduro wifi going for discovery"
                concurrentQueue.async(flags:.barrier) {
                    self.getIP()
                }
                concurrentQueue.async() {
                              self.getform()
                          }
//                getIP()
            }
            
        }
        else
        {
//            connectionLabel.text="4G apprelay case"
            
            controller = Controller(serial: serial)
            controller.setPassword(password: password)
            ControllerconnectionImpl.getInstance().setController(controller: controller)
            ControllerconnectionImpl.getInstance().getController().swapToAppRelay()
            concurrentQueue.async(flags:.barrier) {
                               self.getF11(setip: false,directfourg: true)
                           }
            concurrentQueue.async(flags:.barrier) {
                            self.getVersion()
                        }
                        concurrentQueue.async(flags:.barrier) {
                            self.exchangeKeys()
                        }
            concurrentQueue.async() {
                self.getform()
            }
            starthandler()
        }
        
    }
    
    func getform()  {
        if(Util.GetDefaultsBool(key: ControllerconnectionImpl.getInstance().getController().getSerial()) == false)
        {
            let url = URL(string: "https://aduro.prevas-dev.pw/api/device/" + ControllerconnectionImpl.getInstance().getController().getSerial() + "/nbe/verify")!
                  var request = URLRequest(url: url)
                  request.httpMethod = "GEt"
                  NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {(response, data, error) in
                      guard let data = data else { return }
                      print(String(data: data, encoding: .utf8)!)
                      let value = String(data: data, encoding: .utf8)!
                      if(value == "true")
                      {
                        Util.SetDefaultsBool(key: ControllerconnectionImpl.getInstance().getController().getSerial(), value: true)
                      }else if (value == "false")
                      {
                          guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "FormViewController") as? FormViewController else { return}

                          sVC.modalPresentationStyle = .fullScreen
                          self.present(sVC, animated: true)
                      }
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
    func getf11() {
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
                                                DispatchQueue.main.async {
                                                    self.updateValues()
                                                }
        //                                           self.exchangeKeys()
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
                                                        self.checkfirmwareHasToUpdate(response: ControllerResponseImpl)
//                                                        self.versionText.text=ControllerResponseImpl.getPayload()
                }
                   }
           
       
    }
    func checkfirmwareHasToUpdate(response : ControllerResponseImpl)
    {
//        self.UpdateFirmware(payload: "")

        let splitString : [String] = response.getDiscoveryValues()
        if(splitString.count > 0)
        {
            if(Constants.version >= Int(splitString[3])!)
                   {
                       if(Constants.build > Int(splitString[4])!)
                       {
                           self.UpdateFirmware(payload: "")
                       }
                   }
        }
       
    }
    func UpdateFirmware(payload: String) {
        
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "FirmwareUpdateDialogeViewController") as?
                 FirmwareUpdateDialogeViewController else { return}
             sVC.modalPresentationStyle = .overCurrentContext
             sVC.modalTransitionStyle = .crossDissolve
             sVC.delegate=self
//             sVC.delegate=self
             self.present(sVC, animated: true)
        
        
        
//          let alert = UIAlertController(title: "", message: "Controller firmware is outdated click to Update?", preferredStyle: UIAlertController.Style.alert)
//
//          // add the actions (buttons)
//          alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: nil))
//          alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler:
//              { action in
//                  self.stopHandler()
//                  self.startfirmware()
//
//          }))
//          self.present(alert, animated: true, completion: nil)
      }
    func startfirmware() ->  Void {
          let packetSize = 512
                let filePath = Bundle.main.path(forResource: "aduro_0705_30_u.dat", ofType: nil)
                let nsdata = NSData(contentsOfFile: filePath!)
                let stream: InputStream = InputStream(data: nsdata! as Data)
                
                let sendCount = nsdata!.length / packetSize;
                let remain = nsdata!.length % packetSize
                print(nsdata!.length)
                print(String (sendCount))
                print(String(remain))
                stream.open()
                let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.annularDeterminate
        //        loadingNotification.label.text = "Loading"
                loadingNotification.detailsLabel.text = "Updating Firmware"
                if (stream.hasBytesAvailable){
                    var buffer = [UInt8](repeating: 0, count: nsdata!.length)
                    //                     let length1 = stream.read(&buffer, maxLength: buffer.count)
                    stream.read(&buffer, maxLength: buffer.count)
                    //                        if(length1 > 0){
                    let data = Data(_: buffer)
                    let bytesdata=data.toArray(type: UInt8.self)
                    var k=0
//                    concurrentQueue.async(flags:.barrier) {
//                        self.recursive(start: 0, max: sendCount, bytesdata: bytesdata,packetSize: packetSize,remain: remain,totalLength: String(nsdata!.length),loader: loadingNotification)
//                    }

                    self.recursive2(start: 0, max: sendCount, bytesdata: bytesdata,packetSize: packetSize,remain: remain,totalLength: String(nsdata!.length),loader: loadingNotification)
                   
                }else
                {
                    starthandler()
                    loadingNotification.hide(animated: true)
                    print("no bytes")
                }
    }
    func recursive2(start:Int,max:Int,bytesdata:[UInt8],packetSize:Int,remain:Int,totalLength:String,loader:MBProgressHUD)
      {
          if(start<max){
              let fromIndex = start * packetSize
              let bytesbuffer = bytesdata[fromIndex..<(fromIndex + packetSize)]
              var offset = String(start * packetSize + 1000000)
              offset = String(offset.dropFirst())
              var fullbuffer : [UInt8] = [UInt8]()
              let finaloffset : [UInt8] = Array(offset.utf8)
              fullbuffer.append(contentsOf: finaloffset)
              fullbuffer.append(contentsOf: bytesbuffer)
              var xorcheck : UInt8 = 0
              for k in 0..<fullbuffer.count
              {
                  xorcheck = xorcheck ^ fullbuffer[k]
              }
              fullbuffer.append(xorcheck)
              print("-------------------")
              var totalsend=Float(offset)
              var totallengthinfloat=Float(totalLength)
              loader.progress=totalsend!/totallengthinfloat!
              ControllerconnectionImpl.getInstance().requestSetFirmwareUpdate(key: "misc.push_version", value: fullbuffer, encryptionMode: " ") { (ControllerResponseImpl) in
                  if(ControllerResponseImpl.getStatusCode()=="0")
                  {
//                      print("got response")
                    print("success start value perfore \(start) : after increment \(start+1)")
                      self.recursive2(start: start+1, max: max, bytesdata: bytesdata, packetSize: packetSize,remain: remain,totalLength: totalLength,loader: loader)
                  }else
                  {
//                      print("got error")
                    print("error happen start value \(start) : now sending again \(start)")
                      self.recursive2(start: start, max: max, bytesdata: bytesdata, packetSize: packetSize,remain: remain,totalLength: totalLength,loader:loader)
                      
                  }
              }
          }
          if(start>=max)
          {
              print("last bytes")
              //            last bytes here
              let fromIndex = max * packetSize
              let bytesbuffer = bytesdata[fromIndex..<(fromIndex + remain)]
              var offset = String(max * packetSize + 1000000)
              offset = String(offset.dropFirst())
              var fullbuffer : [UInt8] = [UInt8]()
              let finaloffset : [UInt8] = Array(offset.utf8)
              fullbuffer.append(contentsOf: finaloffset)
              fullbuffer.append(contentsOf: bytesbuffer)
              var xorcheck : UInt8 = 0
              for k in 0..<fullbuffer.count
              {
                  xorcheck = xorcheck ^ fullbuffer[k]
              }
              fullbuffer.append(xorcheck)
              print(fullbuffer.count)
              var totalsend=Float(offset)
              var totallengthinfloat=Float(totalLength)
              loader.progress=totalsend!/totallengthinfloat!
              ControllerconnectionImpl.getInstance().requestSetFirmwareUpdate(key: "misc.push_version", value: fullbuffer, encryptionMode: " ")
              {
                  (ControllerResponseImpl) in
                  
                  if(ControllerResponseImpl.getStatusCode()=="0")
                  {
                      print("last bytes got response")
                      ControllerconnectionImpl.getInstance().requestSet(key: "misc.push_prog_size", value: totalLength, encryptionMode: "-")
                      {
                          (ControllerResponseImpl) in
                          
                          if(ControllerResponseImpl.getStatusCode()=="0")
                          {
                              print(" final of size got response")
                              self.starthandler()
                              loader.hide(animated: true)
                          }else
                          {
                              print("got error")
                               self.starthandler()
                              loader.hide(animated: true)
                          }
                      }
                  }else
                  {
                      print("got error")
                       self.starthandler()
                      loader.hide(animated: true)
                  }
              }
          }
      }
    func recursive(start:Int,max:Int,bytesdata:[UInt8],packetSize:Int,remain:Int,totalLength:String,loader:MBProgressHUD)
      {
          if(classvar<max){
              let fromIndex = start * packetSize
              let bytesbuffer = bytesdata[fromIndex..<(fromIndex + packetSize)]
              var offset = String(start * packetSize + 1000000)
              offset = String(offset.dropFirst())
              var fullbuffer : [UInt8] = [UInt8]()
              let finaloffset : [UInt8] = Array(offset.utf8)
              fullbuffer.append(contentsOf: finaloffset)
              fullbuffer.append(contentsOf: bytesbuffer)
              var xorcheck : UInt8 = 0
              for k in 0..<fullbuffer.count
              {
                  xorcheck = xorcheck ^ fullbuffer[k]
              }
              fullbuffer.append(xorcheck)
              print("-------------------")
              var totalsend=Float(offset)
              var totallengthinfloat=Float(totalLength)
//            DispatchQueue.main.async {
//                loader.progress=totalsend!/totallengthinfloat!
//            }
          
              ControllerconnectionImpl.getInstance().requestSetFirmwareUpdate(key: "misc.push_version", value: fullbuffer, encryptionMode: " ") { (ControllerResponseImpl) in
                  if(ControllerResponseImpl.getStatusCode()=="0")
                  {
//                      print("got response")
                    DispatchQueue.main.async {
                                   loader.progress=totalsend!/totallengthinfloat!
                               }
                    self.concurrentQueue.async(flags:.barrier)
                    {
                        print("success start value perfore \(self.classvar) : after increment \(self.classvar+1)")
                        self.classvar=self.classvar+1
                        self.recursive(start: self.classvar+1
                            , max: max, bytesdata: bytesdata, packetSize: packetSize,remain: remain,totalLength: totalLength,loader: loader)
                    }
                  }else
                  {
//                    print("got error")
                    self.concurrentQueue.async(flags:.barrier)
                    {
                        print("error happen start value \(self.classvar) : now sending again \(self.classvar)")
                        self.recursive(start: self.classvar, max: max, bytesdata: bytesdata, packetSize: packetSize,remain: remain,totalLength: totalLength,loader:loader)
                    }
                      
                  }
              }
            }
          
          if(start>=max)
          {
               print("last bytes")
            lastbytes(start: start, max: max, bytesdata: bytesdata, packetSize: packetSize, remain: remain, totalLength: totalLength, loader: loader)
           
        
          }
      }
    
    func lastbytes(start:Int,max:Int,bytesdata:[UInt8],packetSize:Int,remain:Int,totalLength:String,loader:MBProgressHUD)
    {
     
                     print("last bytes")
                     //            last bytes here
                     let fromIndex = max * packetSize
                     let bytesbuffer = bytesdata[fromIndex..<(fromIndex + remain)]
                     var offset = String(max * packetSize + 1000000)
                     offset = String(offset.dropFirst())
                     var fullbuffer : [UInt8] = [UInt8]()
                     let finaloffset : [UInt8] = Array(offset.utf8)
                     fullbuffer.append(contentsOf: finaloffset)
                     fullbuffer.append(contentsOf: bytesbuffer)
                     var xorcheck : UInt8 = 0
                     for k in 0..<fullbuffer.count
                     {
                         xorcheck = xorcheck ^ fullbuffer[k]
                     }
                     fullbuffer.append(xorcheck)
                     print(fullbuffer.count)
                     var totalsend=Float(offset)
                     var totallengthinfloat=Float(totalLength)
        DispatchQueue.main.async {

            loader.progress=totalsend!/totallengthinfloat!
        }
                   
                              
                     ControllerconnectionImpl.getInstance().requestSetFirmwareUpdate(key: "misc.push_version", value: fullbuffer, encryptionMode: " ")
                     {
                         (ControllerResponseImpl) in
                         
                         if(ControllerResponseImpl.getStatusCode()=="0")
                         {
                                 print("last bytes got response")
                                self.concurrentQueue.async(flags:.barrier) {
                                    self.setvalue(key: totalLength, loader: loader)
                            }
                            
                         }else
                         {
                            DispatchQueue.main.async {
                                print("got error")
                                 self.starthandler()
                                loader.hide(animated: true)
                            }
                         }
                     
                    }
                 
    }
    func setvalue(key:String,loader:MBProgressHUD)  {
          ControllerconnectionImpl.getInstance().requestSet(key: "misc.push_prog_size", value: key, encryptionMode: "-")
                                   {
                                       (ControllerResponseImpl) in
                                       
                                       if(ControllerResponseImpl.getStatusCode()=="0")
                                       {
                                        DispatchQueue.main.async {

                                            print(" final of size got response")
                                            self.starthandler()
                                            loader.hide(animated: true)
                                        }
                                       }else
                                       {
                                        DispatchQueue.main.async {
                                            
                                            print("got error")
                                             self.starthandler()
                                            loader.hide(animated: true)
                                        }
                                       }
                                   }
    }
    
    func setVersionText(variable:ControllerResponseImpl)  {
        //First get the nsObject by defining as an optional anyObject
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?

        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        
        let slpitstring : [String] = variable.getDiscoveryValues()
        if(slpitstring.count > 0)
        {
            if(slpitstring[1] == ControllerconnectionImpl.getInstance().getController().getSerial())
            {
                let finalString = "v"+version+"/"+slpitstring[3]+"."+slpitstring[4]+"/"+slpitstring[1]
                self.versionText.text=finalString
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
                if let val = ControllerResponseImpl.GetReadValueForKeyExchange()["rsa_key"]
                {
                     RSAHelper().loadPubKey(key: val)
                    self.concurrentQueue.async(flags:.barrier){
                     self.setXtea()
                     }
                }else
                {
                    print("wrong response")
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
                                self.concurrentQueue.async
                                    {
                                    self.setXtea()
                                }
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
            
//            update progress bar

            var thisRect = myImageView!.frame
            let xvalueOfYellow = Float(stringMap[IControllerConstants.coYellow]!)
            thisRect.origin.x = CGFloat(xvalueOfYellow!/1050*100*1.5)
            myImageView?.frame=thisRect
            
            var thisRect1 = myImageViewRed!.frame
            let xvalueOfRed = Float(stringMap[IControllerConstants.coRed]!)
            thisRect1.origin.x = CGFloat(xvalueOfRed!/1050*100*1.5)
            myImageViewRed?.frame=thisRect1
            
            
            let valueofprogress = Float(stringMap[IControllerConstants.oxygen]!)
            let finalfloat = valueofprogress!/100
            myProgressView?.progress=finalfloat
//            myProgressView?.progress=1.4
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
        print("start handler")
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
    //////
    
    private var myProgressView:CustomProgressView?
    private var myImageView : UIImageView?
    private var myImageViewRed : UIImageView?
    @IBOutlet weak var myCustomView: UIView!
    private func createNewUIProgressView() -> Void {
        myProgressView = CustomProgressView()
        myProgressView?.progress = 0.5
        
        myProgressView?.progressTintColor = UIColor(red: 0/255, green: 229/255, blue: 171/255, alpha: 1)
        myProgressView?.trackTintColor = UIColor.clear
        
        myProgressView!.frame = CGRect(x: 10, y: 8, width: 150, height: 100)          //x is left position, y is right position
        myProgressView?.trackImage = #imageLiteral(resourceName: "backgroundProgressView")
    }
    
    func createCustomImageViews() -> Void {
        let yellowXAxisVal = 15, redXAxisVal = 100
        
        myImageView = UIImageView(frame: CGRect(x: yellowXAxisVal, y: 8, width: 3, height: 20))
        myImageViewRed = UIImageView(frame: CGRect(x: redXAxisVal, y: 8, width: 3, height: 20))
        myImageView?.image = #imageLiteral(resourceName: "yellowImg")
        myImageViewRed?.image = #imageLiteral(resourceName: "redImg")
    }
    
    private func addSubViews() -> Void {
        myCustomView.addSubview(myProgressView!)
        myCustomView.addSubview(myImageView!)
        myCustomView.addSubview(myImageViewRed!)
    }
    
    
    class CustomProgressView: UIProgressView {
        
        @IBInspectable var trackHeight: CGFloat = 20
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            let newSize = CGSize(width: 150, height: trackHeight)
            return newSize;
        }
    }
}
