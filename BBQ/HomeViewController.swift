//
//  BBQAdjustmentViewController.swift
//  BBQ
//
//  Created by ps on 29/03/2021.
//  Copyright © 2021 nbe. All rights reserved.
//

import UIKit
import Foundation
import FGRoute
import MBProgressHUD
import CoreLocation
import AVFoundation


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
    var alarmSoundEffect: AVAudioPlayer?
    var alarmSoundTimer: Timer?
    var alarmSoundTimerCount: Int!
    var f11Values: [String:String] = [:]
    var loadingNotification : MBProgressHUD!


    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var greyScreenView: UIView!
    @IBOutlet weak var lockScreenView: UIView!
    @IBOutlet weak var unlockBtn: UIButton!
    
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
    @IBOutlet weak var stateStatus: UIButton!
    @IBOutlet weak var flagsSleepStatus: UIImageView!
    @IBOutlet weak var bbqFixedPowerStatus: UIImageView!
    @IBOutlet weak var powerPctStatus: UILabel!
    @IBOutlet weak var powerPctPercentageStatus: UILabel!
    @IBOutlet weak var bbqBuzzerImage: UIButton!
    
    @IBOutlet weak var bbqNewView: UIView!
    @IBOutlet weak var bbqOldView: UIView!
    
    
    @IBOutlet weak var bbqFixedTempBtn: UIButton!
    @IBOutlet weak var bbqMeatTemp1Btn: UIButton!
    @IBOutlet weak var bbqMeatTemp2Btn: UIButton!
    @IBOutlet weak var generalRotationTimeBtn: UIButton!
    @IBOutlet weak var smokeLevelBtn: UIButton!
    @IBOutlet weak var smokeTimerBtn: UIButton!
    @IBOutlet weak var bbqFixedPowerBtn: UIButton!
    
    
    @IBOutlet weak var bbqFixedTempSlider: CustomSlider!
    @IBOutlet weak var bbqMeatTemp1Slider: CustomSlider!
    @IBOutlet weak var bbqMeatTemp2Slider: CustomSlider!
    @IBOutlet weak var generalRotationTimeSlider: CustomSlider!
    @IBOutlet weak var smokeLevelSlider: CustomSlider!
    @IBOutlet weak var smokeTimerSlider: CustomSlider!
    @IBOutlet weak var bbqFixedPower: CustomSlider!
    
    @IBOutlet weak var bbqTempLbl: UILabel!
    @IBOutlet weak var meatTemp1Lbl: UILabel!
    @IBOutlet weak var meatTemp2Lbl: UILabel!
    @IBOutlet weak var bbqTempUnitLbl: UILabel!
    @IBOutlet weak var meatTemp1UnitLbl: UILabel!
    @IBOutlet weak var meatTemp2UnitLbl: UILabel!
    
    @IBOutlet weak var oldBBQTemp1Lbl: UILabel!
    @IBOutlet weak var oldBBQTemp2Lbl: UILabel!
    @IBOutlet weak var oldBBQTemp3Lbl: UILabel!
    @IBOutlet weak var oldBBQMeatTemp1Lbl: UILabel!
    @IBOutlet weak var oldBBQMeatTemp2Lbl: UILabel!
    
    @IBOutlet weak var versionText: UILabel!

    var timer: Timer!
    var restartTimer:Timer!
    var countDownTimermode1 : Timer!
    var simulationMode : Timer!
    var tempUnit: String = "C"
    var sliderValues = [bbq.fixed_temperature:["C":["min":40, "max":300], "F":["min":100, "max":570]], bbq.meat_temp_1:["C":["min":0, "max":90], "F":["min":30, "max":190]], bbq.meat_temp_2:["C":["min":0, "max":90], "F":["min":30, "max":190]]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterbackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(lockScreen), name: Notification.Name.TimeOutUserInteraction, object: nil)
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(self.lockScreenPressed))
        lockScreenView.addGestureRecognizer(tapgesture)
        
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
                concurrentQueue.async(flags:.barrier){
                    self.getVersion()
                }
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
    
    @objc func lockScreenPressed(){
        showToast(message: Language.getInstance().getlangauge(key: "screen_is_locked"))
    }
    
    @objc func appWillEnterForeground() {
        print("app in foreground")
        starthandler()
    }
    @objc func appWillEnterbackground() {
        print("app in background")
        stopHandler()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        stopHandler()
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")
        stopHandler()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("start handler")
        starthandler()
    }
    
    
    @objc func lockScreen(){
        lockScreenView.isHidden = false
        unlockBtn.isHidden = false
    }
    
    func unlockScreen(){
        lockScreenView.isHidden = true
        unlockBtn.isHidden = true
    }
    
    func greyScreen(){
        greyScreenView.isHidden = false
    }
    
    func clearGreyScreen(){
        greyScreenView.isHidden = true
    }
    
    
    func getF11Value(_ key: String)->String?{
        if f11Values[key] != nil {
            if Int(f11Values[key]!) == 0 {
                return "OFF"
            } else {
                return f11Values[key]
            }
        } else {
            return nil
        }
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
        let temp_unit =  "°"+self.tempUnit
        self.bbqTempLbl.text = f11Values[Values.bbq_temperature] ?? "0"
        self.bbqTempUnitLbl.text = temp_unit
        
        let meat_temp1 = Int(f11Values[Values.meat_temperature_1] ?? "0")!
        let meat_temp2 = Int(f11Values[Values.meat_temperature_2] ?? "0")!
        
        if meat_temp1 > 990 {
            self.meatTemp1Lbl.isHidden = true
            self.meatTemp1UnitLbl.isHidden = true
        } else {
            self.meatTemp1Lbl.text = "\(meat_temp1)"
            self.meatTemp1UnitLbl.text = temp_unit
            self.meatTemp1Lbl.isHidden = false
            self.meatTemp1UnitLbl.isHidden = false
        }
        
        if meat_temp2 > 990 {
            self.meatTemp2Lbl.isHidden = true
            self.meatTemp2UnitLbl.isHidden = true
        } else {
            self.meatTemp2Lbl.text = "\(meat_temp2)"
            self.meatTemp2UnitLbl.text = temp_unit
            self.meatTemp2Lbl.isHidden = false
            self.meatTemp2UnitLbl.isHidden = false
        }
    }
    
    func setupOldBBQLabels(){
        self.oldBBQTemp1Lbl.text = f11Values[Values.bbq_temperature_1] ?? "0"
        self.oldBBQTemp2Lbl.text = f11Values[Values.bbq_temperature_2] ?? "0"
        self.oldBBQTemp3Lbl.text = f11Values[Values.bbq_temperature_3] ?? "0"
        
        
        let meat_temp1 = Int(f11Values[Values.meat_temperature_1] ?? "0")!
        let meat_temp2 = Int(f11Values[Values.meat_temperature_2] ?? "0")!
        
        if meat_temp1 > 990 {
            self.oldBBQMeatTemp1Lbl.isHidden = true
        } else {
            self.oldBBQMeatTemp1Lbl.text = "\(meat_temp1)"
            self.oldBBQMeatTemp1Lbl.isHidden = false
        }
        
        if meat_temp2 > 990 {
            self.oldBBQMeatTemp2Lbl.isHidden = true
        } else {
            self.oldBBQMeatTemp2Lbl.text = "\(meat_temp2)"
            self.oldBBQMeatTemp2Lbl.isHidden = false
        }
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
                    
                    self.setVersionText(variable: ControllerResponseImpl)
                    self.checkfirmwareHasToUpdate(response: ControllerResponseImpl)
                }
                
            }
        }
        
        
    }
    
    func setVersionText(variable:ControllerResponseImpl)  {
        //First get the nsObject by defining as an optional anyObject
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        let build: String? = Bundle.main.infoDictionary!["CFBundleVersion"] as! String?

        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        let finaltext : String
        if(build?.count == 1)
        {
            finaltext = version + ".0" + build! as! String

        }else
        {
            finaltext = version + "." + build! as! String

        }
        
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
        self.setTempUnit()
        self.setupBuzzer()
        self.setupSliders()
        self.setCurrentValues()
        self.setupStatusArea()
        self.setupBBQView()
    }
    
    func setTempUnit(){
        self.tempUnit = Int(f11Values[misc.temp_unit] ?? "0") == 1 ? "F" : "C"
    }
    
    func setCurrentValues(){
        bbqFixedTempBtn.setAttributedTitle(NSAttributedString(string: f11Values[bbq.fixed_temperature] ?? "-"), for: .normal)
        bbqMeatTemp1Btn.setAttributedTitle(NSAttributedString(string: f11Values[bbq.meat_temp_1] ?? "-"), for: .normal)
        bbqMeatTemp2Btn.setAttributedTitle(NSAttributedString(string: f11Values[bbq.meat_temp_2] ?? "-"), for: .normal)
        generalRotationTimeBtn.setAttributedTitle(NSAttributedString(string: f11Values[general.rotation_time] ?? "-"), for: .normal)
        smokeLevelBtn.setAttributedTitle(NSAttributedString(string: f11Values[smoke.level] ?? "-"), for: .normal)
        smokeTimerBtn.setAttributedTitle(NSAttributedString(string: f11Values[smoke.timer] ?? "-"), for: .normal)
        bbqFixedPowerBtn.setAttributedTitle(NSAttributedString(string: f11Values[bbq.fixed_power] ?? "-"), for: .normal)
    }
    
    func setupBuzzer(){
        let buzzer = Int(f11Values[bbq.use_buzzer] ?? "0")
        if buzzer == 0 {
            bbqBuzzerImage.setImage(UIImage(named: "Buzzer off icon"), for: .normal)
            
            self.playSound(false)
            if alarmSoundTimerCount != nil {
                alarmSoundTimer?.invalidate()
                alarmSoundTimer = nil
            }
            
            
        } else if buzzer == 1 {
            
            bbqBuzzerImage.setImage(UIImage(named: "Buzzer on icon"), for: .normal)
            
            let buzzer_1 = Int(f11Values[Values.buzzer_1_active] ?? "0")
            let buzzer_2 = Int(f11Values[Values.buzzer_2_active] ?? "0")
            
            if buzzer_1 == 1 || buzzer_2 == 1 {
                
                if alarmSoundTimer == nil {
                    alarmSoundTimerCount = 0
                    alarmSoundTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (Timer) in
                        self.playSound(true)
                        if self.alarmSoundTimerCount > 30 {
                            self.playSound(false)
                            Timer.invalidate()
                            self.alarmSoundTimer = nil
                        }
                        self.alarmSoundTimerCount += 2
                    })
                }
            }
        }
    }
    
    func playSound(_ flag: Bool) {
        if flag {
            let path = Bundle.main.path(forResource: "beep", ofType: "mp3")!
            let url = URL(fileURLWithPath: path)
            
            do {
                self.alarmSoundEffect = try AVAudioPlayer(contentsOf: url)
                self.alarmSoundEffect?.play()
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            } catch {
                print("Audio File Not Found")
            }
            
        } else {
            alarmSoundEffect?.stop()
        }
        
        
    }
    
    func setupStatusArea(){
        onOffButton.isHidden = f11Values[Values.super_state] == nil
        generalRotationActiveStatus.isHidden = (Int(f11Values[general.rotation_time] ?? "0")! > 0 && Int(f11Values[general.rotation_active] ?? "0")! != 0) ? false : true
        flagsIgniteStatus.isHidden = (Int(f11Values[Values.flags_ignite] ?? "0") == 0) ? true : false
        smokeTimerStatus.isHidden = !(Int(f11Values[smoke.timer] ?? "0")! > 0 && Int(f11Values[Values.flags_smoke] ?? "0") != 0)
        smokeTimerCountStatus.text = (Int(f11Values[smoke.timer] ?? "0")! > 0) ? setupSmokeTimer() : "00:00"
        smokeTimerCountStatus.isHidden = (Int(f11Values[Values.flags_smoke] ?? "0") != 1)
//        flagsSmokeStatus.isHidden = (Int(f11Values[Values.flags_smoke] ?? "0")! > 0) ? false : true
        stateStatus.isHidden = (Int(f11Values[Values.state] ?? "0")! >= 5 && Int(f11Values[Values.state] ?? "0")! <= 11 ) ? false : true
        flagsSleepStatus.isHidden = (Int(f11Values[Values.flags_sleep] ?? "0")! != 0) ? false : true
        bbqFixedPowerStatus.isHidden = (Int(f11Values[bbq.fixed_power] ?? "0")! > 0) ? false : true
        if let power_pct = f11Values[Values.power_pct]
         {
            powerPctStatus.text = "\(power_pct)"
            powerPctPercentageStatus.isHidden = false
        } else {
            powerPctStatus.text = ""
            powerPctPercentageStatus.isHidden = true
        }
        
    }
    
    func setupSmokeTimer()->String{
        
        let totalMinutes = Int(f11Values[smoke.timer]!)!
        let hours = totalMinutes / 60
        let minutes = totalMinutes - (hours * 60)
        return "\(hours<10 ? "0" : "")\(hours):\(minutes<10 ? "0" : "")\(minutes)"
    }
    
    
    
    func setupSliders(){
        
        setupSlider(slider: bbqFixedTempSlider, valueName: bbq.fixed_temperature, value: Int(f11Values[bbq.fixed_temperature] ?? "\(sliderValues[bbq.fixed_temperature]![tempUnit]!["min"]!)" )!, min:sliderValues[bbq.fixed_temperature]![tempUnit]!["min"]!, max: sliderValues[bbq.fixed_temperature]![tempUnit]!["max"]!, interval: 10)
        setupSlider(slider: bbqMeatTemp1Slider, valueName:bbq.meat_temp_1, value: Int(f11Values[bbq.meat_temp_1] ?? "\(sliderValues[bbq.meat_temp_1]![tempUnit]!["min"]!)" )! , min: sliderValues[bbq.meat_temp_1]![tempUnit]!["min"]!, max: sliderValues[bbq.meat_temp_1]![tempUnit]!["max"]!, interval: 2)
        setupSlider(slider: bbqMeatTemp2Slider, valueName: bbq.meat_temp_2,  value: Int(f11Values[bbq.meat_temp_2] ?? "\(sliderValues[bbq.meat_temp_2]![tempUnit]!["min"]!)" )!, min: sliderValues[bbq.meat_temp_2]![tempUnit]!["min"]!, max: sliderValues[bbq.meat_temp_2]![tempUnit]!["max"]!, interval: 2)
        setupSlider(slider: generalRotationTimeSlider, valueName: general.rotation_time,  value: Int(f11Values[general.rotation_time] ?? "0" )!, min: 0, max: 30, interval: 5)
        setupSlider(slider: smokeLevelSlider, valueName: smoke.level, value: Int(f11Values[smoke.level] ?? "0" )!, min: 0, max: 5, interval: 1)
        setupSlider(slider: smokeTimerSlider, valueName: smoke.timer, value: Int(f11Values[smoke.timer] ?? "0" )!, min: 0, max: 1200, interval: 15)
        setupSlider(slider: bbqFixedPower, valueName: bbq.fixed_power, value: Int(f11Values[bbq.fixed_power] ?? "0" )!, min: 0, max: 100, interval: 10)
    }
    
    func setupSlider(slider: CustomSlider, valueName: String, value: Int, min: Int, max: Int, interval: Int){
        slider.delegate = self
        slider.sliderName = valueName
        slider.configureSlider(value: value, minValue: min, maxValue: max,  interval: interval)
        slider.setThumbColor(.red)
        slider.setTrackColor(.red)
    }
    
    func starthandler()
    {
        print("start handler")
        ScreenTouchTimer.startIdleTimer()
        unlockScreen()
        if(timer == nil)
        {
            var f11NoResponseCount:Int = 0
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {
                (Timer) in
                
                self.concurrentQueue.async {
                    ControllerconnectionImpl.getInstance().requestF11Identified { (ControllerResponseImpl) in
                        if(ControllerResponseImpl.getPayload().contains("nothing"))
                        {
                            f11NoResponseCount += 1
                            
                            if f11NoResponseCount >= 3 {
                                self.greyScreen()
                            }
                            print("f11 no response")
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                self.f11Values = ControllerResponseImpl.getF11Values()
                                print(self.f11Values)
                                self.updateValues()
                                
                                if f11NoResponseCount >= 3 {
                                    self.clearGreyScreen()
                                }
                                f11NoResponseCount = 0
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
        ScreenTouchTimer.stopIdleTimer()

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
        print("f11AfterUpdate")
        ControllerconnectionImpl.getInstance().requestF11Identified
        {
            (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing")){
                print("f11values error")
            }
            else
            {
                DispatchQueue.main.async {
                self.f11Values = ControllerResponseImpl.getF11Values()
                print("f11Values", self.f11Values)
                self.updateValues()

                }
            }
            self.loadingNotification.hide(animated: true)

        }
    }
    
    
    func setvalue(key:String, value:String) {
        
        DispatchQueue.main.async {
            self.loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.loadingNotification.mode = MBProgressHUDMode.indeterminate
            self.loadingNotification.label.text = Language.getInstance().getlangauge(key: "loading")
            self.loadingNotification.detailsLabel.text = Language.getInstance().getlangauge(key:"please_wait")
        }
        
        ControllerconnectionImpl.getInstance().requestSet(key: key, value: value, encryptionMode: " ") {
            (ControllerResponseImpl) in
            print("setvalue response received")
            
            if(ControllerResponseImpl.getPayload().contains("nothing")){
                print("error")
                DispatchQueue.main.async {
                    self.loadingNotification.hide(animated: true)
                }
            }
            else
            {
                self.concurrentQueue.async(flags: .barrier) {
                    self.getF11AfterUpdate()
                }
            }
        }
        
    }
    
    func startfirmware() ->  Void {
        let packetSize = 512
        UIApplication.shared.isIdleTimerDisabled = true
        
        let filePath = Bundle.main.path(forResource: "bbq_2_53_u.dat", ofType: nil)
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
    
    
    func showDialogBox(titleText: String, descriptionText: String){
        let dialogBox = DialogBox()
        dialogBox.configure(titleText: titleText, descriptionText: descriptionText, okBtnText: Language.getInstance().getlangauge(key: "ok"))
        dialogBox.modalPresentationStyle = .overCurrentContext
        dialogBox.modalTransitionStyle = .crossDissolve
        self.present(dialogBox, animated: true)
    }
    
    func showConfirmDialogBox(titleText: String, descriptionText: String, cancelText: String?=nil, confirmText:String?=nil, completionHandler: @escaping (()->Void)){
        let confirmDialogBox = ConfirmDialogBox()
        confirmDialogBox.configure(titleText: titleText, descriptionText: descriptionText, cancelText: (cancelText != nil ? cancelText! : Language.getInstance().getlangauge(key: "no")), confirmText:(confirmText != nil ? confirmText! : Language.getInstance().getlangauge(key: "yes"))) {
            completionHandler()
        }
       
        confirmDialogBox.modalPresentationStyle = .overCurrentContext
        confirmDialogBox.modalTransitionStyle = .crossDissolve
        self.present(confirmDialogBox, animated: true)
    }
    
   
    // MARK: - Actions
    
    @IBAction func onOffBtnPressed(_ sender: UITapGestureRecognizer) {
        
        if let superState = self.f11Values[Values.super_state] {
            let onOffAlarm = Int(superState)
            var textKey:String = ""
            var payload:String = ""
            
            if(onOffAlarm==0){
                textKey = "lng_on_text"
                payload = misc.start
            }else if(onOffAlarm==1){
                textKey = "lng_off_txt"
                payload = misc.stop
            }else if(onOffAlarm==2){
                textKey = "lng_alarmreset_txt"
                payload = misc.reset_alarm
            }
            
            showConfirmDialogBox(titleText: "", descriptionText: Language.getInstance().getlangauge(key: textKey)) {
                self.concurrentQueue.async(flags:.barrier) {
                    self.setvalue(key: payload, value: "1")
                }
            }
        }
    }
    
    @IBAction func alarmIconPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "state_error_shortText"), descriptionText: Language.getInstance().getlangauge(key: "statu_error_"+(f11Values[Values.state] ?? "5")))
    }
    
    @IBAction func settingsBtnPressed(_ sender: Any) {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "AdjustmentViewController") as?
                AdjustmentViewController else { return}
        sVC.modalPresentationStyle = .fullScreen
        sVC.modalTransitionStyle = .crossDissolve
        self.present(sVC, animated: true)
    }
    
    @IBAction func wifiBtnPressed(_ sender: Any) {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "WizardMainViewController") as?
                WizardMainViewController else { return}
        sVC.modalPresentationStyle = .fullScreen
        sVC.modalTransitionStyle = .crossDissolve
        self.present(sVC, animated: true)
    }
    
    @IBAction func fixedTempBtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "grill_temp_header")+" "+(getF11Value(bbq.fixed_temperature) ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "grill_temp_text"))
    }
    
    @IBAction func meatTemp1BtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "meat_temp_1_header")+" "+(getF11Value(bbq.meat_temp_1) ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "meat_temp_1_text"))
    }
    
    
    @IBAction func meatTemp2BtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "meat_temp_2_header")+" "+(getF11Value(bbq.meat_temp_2) ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "meat_temp_2_text"))
    }
    
    
    @IBAction func rotationTimeBtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "Rotisserie_Rotation_header")+" "+(getF11Value(general.rotation_time) ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "Rotisserie_Rotation_text"))
    }
    
    @IBAction func smokeLevelBtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "Smoke_Level_header")+" "+(getF11Value(smoke.level) ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "Smoke_Level_text"))
    }
    
    @IBAction func smokeTimerBtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "Smoke_Timer_header")+" "+(getF11Value(smoke.timer) ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "Smoke_Timer_text"))
    }
    
    @IBAction func fixedPowerBtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "Fixed_Power_header")+" "+(getF11Value(bbq.fixed_power) ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "Fixed_Power_text"))
    }
    
    @IBAction func bbqBuzzerBtnPressed(_ sender: Any) {
        concurrentQueue.async(flags:.barrier) {
            self.setvalue(key: bbq.use_buzzer, value: self.f11Values[bbq.use_buzzer] ?? "0" == "0" ? "1" : "0")
        }
    }
    
    @IBAction func unlockBtnPressed(_ sender: Any) {
        showConfirmDialogBox(titleText: Language.getInstance().getlangauge(key: "screen_is_locked"), descriptionText: "", cancelText: Language.getInstance().getlangauge(key: "keep_lock"), confirmText: Language.getInstance().getlangauge(key: "unlock")) {
            self.unlockScreen()
        }
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

extension HomeViewController
{
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-150, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
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



