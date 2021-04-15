//
//  BBQAdjustmentViewController.swift
//  BBQ
//
//  Created by ps on 29/03/2021.
//  Copyright © 2021 nbe. All rights reserved.
//

import UIKit
import FGRoute
import MBProgressHUD
import CoreLocation


class HomeViewController: UIViewController, CLLocationManagerDelegate, firmwaredelegate {
    func donedialogStartFirmware() {
        self.stopHandler()
        self.startfirmware()
    }
    
    let concurrentQueue = DispatchQueue(label: "BBQ Adjust Queue", attributes: .concurrent)
    let serialQueue = DispatchQueue(label: "BBQ Serial Queue")
    var serial:String!
    var password:String!
    var fromSplash:Bool!
    var justlangChange:Bool = false
    var locationManager:CLLocationManager!
    var controller: Controller!
    
    var f11Values: [String:String] = [:]
    
    @IBOutlet weak var gradient: gradient!
    @IBOutlet weak var onOffButton: UIImageView!{
        didSet{
            onOffButton.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var generalRotationActiveStatus: UIImageView!
    @IBOutlet weak var flagsIgniteStatus: UIImageView!
    @IBOutlet weak var smokeTimerStatus: UIImageView!
    @IBOutlet weak var smokeTimerCountStatus: UILabel!
    @IBOutlet weak var flagsSmokeStatus: UIImageView!
    @IBOutlet weak var stateStatus: UIImageView!
    @IBOutlet weak var flagsSleepStatus: UIImageView!
    @IBOutlet weak var bbqFixedPowerStatus: UIImageView!
    @IBOutlet weak var powerPctStatus: UILabel!
    @IBOutlet weak var powerPctPercentageStatus: UILabel!
    
    @IBOutlet weak var bbqNewView: UIView!
    @IBOutlet weak var bbqOldView: UIView!
    
    @IBOutlet weak var bbqFixedTempSlider: CustomSlider!
    @IBOutlet weak var bbqMeatTemp1Slider: CustomSlider!
    @IBOutlet weak var bbqMeatTemp2Slider: CustomSlider!
    @IBOutlet weak var generalRotationTimeSlider: CustomSlider!
    @IBOutlet weak var smokeLevelSlider: CustomSlider!
    @IBOutlet weak var smokeTimerSlider: CustomSlider!
    @IBOutlet weak var bbqFixedPower: CustomSlider!
    
    @IBOutlet weak var bbqTemp1Lbl: UILabel!
    @IBOutlet weak var meatTemp1Lbl: UILabel!
    @IBOutlet weak var meatTemp2Lbl: UILabel!
        
    @IBOutlet weak var oldBBQTemp1Lbl: UILabel!
    @IBOutlet weak var oldBBQTemp2Lbl: UILabel!
    @IBOutlet weak var oldBBQTemp3Lbl: UILabel!
    
    var timer: Timer!
    var restartTimer:Timer!
    var countDownTimermode1 : Timer!
    var simulationMode : Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterbackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        updateValues()
        
        if(fromSplash==true)
        {
            
            if(justlangChange)
            {
                concurrentQueue.async(flags:.barrier)
                {
                    self.getF11AfterUpdate()
                }
                concurrentQueue.async(flags:.barrier){
                    self.getVersion()
                }
                starthandler()
            }else{
                Checklocation()
            }
        }
        else
        {
            self.concurrentQueue.async(flags : .barrier) {
                self.getF11(setip: false, directfourg: false)
            }
            self.concurrentQueue.async(flags : .barrier) {
                self.getVersion()
            }
            starthandler()
        }
    }
    
    @objc func appWillEnterForeground() {
           print("app in foreground")
        starthandler()
       }
    @objc func appWillEnterbackground() {
           print("app in background")
        stopHandler()
       }
    
    func setupBBQView(){
        var countLessThan990 = 0
        if f11Values[Values.bbq_temperature_2] != nil {
            let temp1 = Int(f11Values[Values.bbq_temperature_1] ?? "0")!
            let temp2 = Int(f11Values[Values.bbq_temperature_2] ?? "0")!
            let temp3 = Int(f11Values[Values.bbq_temperature_3] ?? "0")!
            if temp1 < 990  {
                countLessThan990+=1
            }
            if temp2 < 990 {
                countLessThan990+=1
            }
            if temp3 < 990 {
                countLessThan990+=1
            }
            
            if countLessThan990 == 1 {
                bbqOldView.isHidden = true
                bbqNewView.isHidden = false
                setupNewBBQLabels()
                Util.SetDefaults(key: Constants.bbqView, value: "new")
            } else if countLessThan990 > 1 {
                bbqNewView.isHidden = true
                bbqOldView.isHidden = false
                setupOldBBQLabels()
                Util.SetDefaults(key: Constants.bbqView, value: "old")
            }
        } else if Util.GetDefaultsString(key: Constants.bbqView) != nil {
            let bbqView = Util.GetDefaultsString(key: Constants.bbqView)
            if bbqView == "old" {
                bbqNewView.isHidden = true
                bbqOldView.isHidden = false
                setupOldBBQLabels()
            } else {
                bbqOldView.isHidden = true
                bbqNewView.isHidden = false
                setupNewBBQLabels()
            }
        }
    }
    
    func setupNewBBQLabels(){
        self.bbqTemp1Lbl.text = f11Values[Values.bbq_temperature_1] ?? "0"
        self.meatTemp1Lbl.text = f11Values[Values.meat_temperature_1] ?? "0"
        self.meatTemp2Lbl.text = f11Values[Values.meat_temperature_2] ?? "0"
    }
    
    func setupOldBBQLabels(){
        self.oldBBQTemp1Lbl.text = f11Values[Values.bbq_temperature_1] ?? "0"
        self.meatTemp1Lbl.text = f11Values[Values.bbq_temperature_2] ?? "0"
        self.meatTemp2Lbl.text = f11Values[Values.bbq_temperature_3] ?? "0"
    }
    
    func Checklocation() {
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                locationManager = CLLocationManager()
                locationManager.delegate=self
                locationManager.requestWhenInUseAuthorization()
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
    
    func checkConnectionType() {
        if(FGRoute.isWifiConnected())
        {
            if let Ssid = FGRoute.getSSID()
            {
                if(Ssid.starts(with: "BBQ-"+serial))
                {
                    
                    controller = Controller(serial: Util.GetDefaultsString(key: Constants.serialKey))
                    controller.setPassword(password: Util.GetDefaultsString(key: Constants.passwordKey))
                    ControllerconnectionImpl.getInstance().setController(controller: controller)
                    ControllerconnectionImpl.getInstance().getController().swapToLocal()
                    print("BBQ wifi")
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
                    print("non bbq wifi")
                    //                self.f11label.text="not aduro wifi going for discovery"
                    concurrentQueue.async(flags:.barrier) {
                        self.getIP()
                    }
                    //                                concurrentQueue.async() {
                    //                                              self.getform()
                    //                                          }
                    //                getIP()
                }
            }else
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
                    self.exchangeKeys()
                }
                //                concurrentQueue.async() {
                //                    self.getform()
                //                }
                starthandler()
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
                self.exchangeKeys()
            }
            //            concurrentQueue.async() {
            //                self.getform()
            //            }
            starthandler()
        }
        
    }
    
    func getIP(){
        
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
                self.starthandler()
                //                self.exchangeKeys()
            }else
            {
                //                normal case change the ip of controller got in response and exchange keys
                print(values[0])
                //                self.f11label.text="got discovery"
                ControllerconnectionImpl.getInstance().getController().SetIp(ip: values[0])
                self.concurrentQueue.async
                {
                    self.getF11(setip: false,directfourg: false)
                }
                self.concurrentQueue.async(flags:.barrier)
                {
                    self.getVersion()
                }
                self.concurrentQueue.async
                {
                    self.exchangeKeys()
                }
                self.starthandler()
                
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
    
    func getVersion()  {
        
        ControllerconnectionImpl.getInstance().requestDiscovery {
            (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                print(" discovery error")
                
            }
            else
            {
                DispatchQueue.main.async {
                    self.checkfirmwareHasToUpdate(response: ControllerResponseImpl)
                }
                
            }
        }
        
        
    }
    
    
    
    func checkfirmwareHasToUpdate(response : ControllerResponseImpl)
    {
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
        self.present(sVC, animated: true)
        
    }
    
    func getF11(setip : Bool,directfourg:Bool)  {
        
        ControllerconnectionImpl.getInstance().getController().setSerial(serial: Util.GetDefaultsString(key: Constants.serialKey))
        ControllerconnectionImpl.getInstance().getController().setPassword(password: Util.GetDefaultsString(key: Constants.passwordKey))
        
        
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
            }
            else
            {
                self.f11Values = ControllerResponseImpl.getF11Values()
                
                DispatchQueue.main.async {
                    self.updateValues()
                }
            }
            
        }
        
    }
    
    func updateValues(){
        self.setupAllSliders()
        self.setupStatusArea()
        self.setupBBQView()
        
    }
    
    func setupStatusArea(){
        generalRotationActiveStatus.isHidden = (Int(f11Values[Values.general_rotation_active] ?? "0") == 0)
        flagsIgniteStatus.isHidden = (Int(f11Values[Values.flags_ignite] ?? "0") == 0) ? true : false
        smokeTimerStatus.isHidden = !(Int(f11Values[Values.smoke_timer] ?? "0")! > 0 && Int(f11Values[Values.flags_smoke] ?? "0") != 0)
        smokeTimerCountStatus.text = (Int(f11Values[Values.smoke_timer] ?? "0")! > 0) ? setupSmokeTimer() : "00:00"
        flagsSmokeStatus.isHidden = (Int(f11Values[Values.flags_smoke] ?? "0")! > 0) ? false : true
        stateStatus.isHidden = (Int(f11Values[Values.state] ?? "0")! >= 5 && Int(f11Values[Values.state] ?? "0")! <= 11 ) ? false : true
        flagsSleepStatus.isHidden = (Int(f11Values[Values.flags_sleep] ?? "0")! != 0) ? false : true
        bbqFixedPowerStatus.isHidden = (Int(f11Values[Values.bbq_fixed_power] ?? "0")! > 0) ? false : true
        if let power_pct = Int(f11Values[Values.power_pct] ?? "0"), power_pct > 0 {
            powerPctStatus.text = "\(power_pct)"
            powerPctPercentageStatus.isHidden = false
        } else {
            powerPctStatus.text = ""
            powerPctPercentageStatus.isHidden = true
        }
        
    }
    
    func setupSmokeTimer()->String{
        
        let totalMinutes = Int(f11Values[Values.smoke_timer]!)!
        let hours = totalMinutes / 60
        let minutes = totalMinutes - (hours * 60)
        return "\(hours<10 ? "0" : "")\(hours):\(minutes<10 ? "0" : "")\(minutes)"
    }
    
   
    
    func setupAllSliders(){
        setupSlider(slider: bbqFixedTempSlider, valueName: Values.bbq_fixed_temperature, value: Int(f11Values[Values.bbq_fixed_temperature] ?? "50" )!, min: 50, max: 300, interval: 10)
        setupSlider(slider: bbqMeatTemp1Slider, valueName:Values.bbq_meat_temp_1, value: Int(f11Values[Values.bbq_meat_temp_1] ?? "50" )! , min: 50, max: 100, interval: 2)
        setupSlider(slider: bbqMeatTemp2Slider, valueName: Values.bbq_meat_temp_2,  value: Int(f11Values[Values.bbq_meat_temp_2] ?? "50" )!, min: 50, max: 100, interval: 2)
        setupSlider(slider: generalRotationTimeSlider, valueName: Values.general_rotation_time,  value: Int(f11Values[Values.general_rotation_time] ?? "0" )!, min: 0, max: 30, interval: 5)
        setupSlider(slider: smokeLevelSlider, valueName: Values.smoke_level, value: Int(f11Values[Values.smoke_level] ?? "0" )!, min: 0, max: 5, interval: 1)
        setupSlider(slider: smokeTimerSlider, valueName: Values.smoke_timer, value: Int(f11Values[Values.smoke_timer] ?? "0" )!, min: 0, max: 300, interval: 15)
        setupSlider(slider: bbqFixedPower, valueName: Values.bbq_fixed_power, value: Int(f11Values[Values.bbq_fixed_power] ?? "0" )!, min: 0, max: 100, interval: 10)
    }
    
    func setupSlider(slider: CustomSlider, valueName: String, value: Int, min: Int, max: Int, interval: Int){
        slider.delegate = self
        slider.sliderName = valueName
        slider.configureSlider(value: value, minValue: min, maxValue: max,  interval: interval)
        slider.setThumbColor(.red)
        slider.setThumbLabelColor(.red)
        slider.setTrackColor(.red)
    }
    
    func starthandler()
    {
        print("start handler")
        if(timer == nil)
        {
            
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {
                (Timer) in
                
                self.concurrentQueue.async {
                    ControllerconnectionImpl.getInstance().requestF11Identified { (ControllerResponseImpl) in
                        if(ControllerResponseImpl.getPayload().contains("nothing"))
                        {
                            print("f11 no response")
                        }
                        else
                        {
                            
                            DispatchQueue.main.async {
                                self.f11Values = ControllerResponseImpl.getF11Values()
                                self.updateValues()
                            }
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
        if(simulationMode != nil)
        {
            simulationMode!.invalidate()
            simulationMode=nil
            //            print("stop timer")
        }
        
    }
    
    func getF11AfterUpdate(){
        
        ControllerconnectionImpl.getInstance().requestF11Identified
        {
            (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing")){
                print("f11values error")
            }
            else
            {
                self.f11Values = ControllerResponseImpl.getF11Values()
                self.updateValues()
                print("f11Values", self.f11Values)
            }
        }
    }
    
    
    func setvalue(key:String, value:String) {
        
        var loadingNotification : MBProgressHUD!
        DispatchQueue.main.async {
            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = Language.getInstance().getlangauge(key: "loading")
            loadingNotification.detailsLabel.text = Language.getInstance().getlangauge(key:"please_wait")
        }
        
        ControllerconnectionImpl.getInstance().requestSet(key: key, value: value, encryptionMode: " ") {
            (ControllerResponseImpl) in
            print("setvalue response received")
            
            if(ControllerResponseImpl.getPayload().contains("nothing")){
                print("error")
                DispatchQueue.main.async {
                    loadingNotification.hide(animated: true)
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self.starthandler()
                    loadingNotification.hide(animated: true)
                }
            }
        }
        
    }
    
    func startfirmware() ->  Void {
        let packetSize = 512
        UIApplication.shared.isIdleTimerDisabled = true
        
        let filePath = Bundle.main.path(forResource: "aduro_0705_34_u.dat", ofType: nil)
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
            UIApplication.shared.isIdleTimerDisabled = false
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
            var stringprogress=Int((totalsend!/totallengthinfloat!)*100)
            loader.detailsLabel.text=String(stringprogress)+"%"
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
                        
                        UIApplication.shared.isIdleTimerDisabled = false
                        self.restartTimerfuncrtion()
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
    func restartTimerfuncrtion()
    {
        if(restartTimer == nil)
        {
            var loadingNotification : MBProgressHUD!
            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = Language.getInstance().getlangauge(key: "lng_afterUpdate")
            restartTimer = Timer.scheduledTimer(withTimeInterval: 70, repeats: false) {
                (Timer) in
                loadingNotification.hide(animated: true)
                self.stopHandler()
                self.resetphone()
                
            }
            RunLoop.current.add(restartTimer, forMode: .common)
        }
    }
    
    func resetphone()   {
        Util.SetDefaultsBool(key: "setWakeLock", value: true)
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "LanguageViewController") as? LanguageViewController else { return}
        
        sVC.modalPresentationStyle = .fullScreen
        self.present(sVC, animated: true)
    }
    // MARK: - Actions
    
    
    @IBAction func onOffBtnPressed(_ sender: UITapGestureRecognizer) {
        let dialog = UIAlertController(title: "Confirmation", message: "Are you sure?", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (UIAlertAction) in
            print("on/off")
        }))
        dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(dialog, animated: true, completion: nil)
        
    }

    @IBAction func settingsBtnPressed(_ sender: Any) {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "AdjustmentViewController") as?
                AdjustmentViewController else { return}
        sVC.modalPresentationStyle = .overCurrentContext
        sVC.modalTransitionStyle = .crossDissolve
        self.present(sVC, animated: true)
    }
    
}

extension HomeViewController: SliderDelegate {
    
    func getSliderValue(value: Float, sliderName: String) {
        concurrentQueue.async(flags:.barrier) {
            self.setvalue(key: sliderName, value: String(format: "%.0f", value))
        }
        print(sliderName, value)
    }
}
