//
//  ServiceMenuViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 28/07/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit
import FGRoute
import MBProgressHUD

class ServiceMenuViewController: UIViewController , PopUpDelegate{
    func handleAction(payloadKEy: String, value: String) {
        setMinMAx(key: payloadKEy, value: value)
    }
    
    func handleInternalAction(key: String, value: String) {
        screenLockTimeValue.text = value
        Util.SetDefaults(key: key, value: value)
//        NotificationCenter.default.post(name: Notification.Name.TimeOutValueChanged, object: nil)
    }
    
  
    
    let concurrentQueue = DispatchQueue(label: "SERVICE Queue", attributes: .concurrent)

    @IBOutlet weak var ignition_sub: UIView!
    @IBOutlet weak var general_sub: UIView!
    @IBOutlet weak var misc_sub: UIView!
    
    
    @IBOutlet weak var ignition_button: UIButton!
    @IBOutlet weak var general_button: UIButton!
    @IBOutlet weak var misc_button: UIButton!
    
    
    
//submenu ignition
    @IBOutlet weak var PowerIgnitionLbl: UILabel!
    @IBOutlet weak var PowerIgnitionOperationLbl: UILabel!
   

    @IBOutlet weak var PowerIgnitionValue: UILabel!
    @IBOutlet weak var PowerIgnitionOperationValue: UILabel!

    
    @IBOutlet weak var PowerIgnitionTouch: UIView!
    @IBOutlet weak var PowerIgnitionOperationTouch: UIView!
   
    
//    submenu General
    @IBOutlet weak var  shutdownTimeLbl: UILabel!
    @IBOutlet weak var  screenLockTimeLbl: UILabel!
    
    @IBOutlet weak var  shaftAlarmLbl: UILabel!
    @IBOutlet weak var  gainPLbl: UILabel!
    @IBOutlet weak var  gainILbl: UILabel!
    @IBOutlet weak var  fanShutdownLbl: UILabel!

    
    @IBOutlet weak var  shutdownTimeValue: UILabel!
    @IBOutlet weak var  screenLockTimeValue: UILabel!
    @IBOutlet weak var  shaftAlarmValue: UILabel!
    @IBOutlet weak var  gainPValue: UILabel!
    @IBOutlet weak var  gainIValue: UILabel!
    @IBOutlet weak var  fanShutdownValue: UILabel!
 
    
    @IBOutlet weak var  shutdownTimeTouch: UIView!
    @IBOutlet weak var  screenLockTimeTouch: UIView!
    @IBOutlet weak var  shaftAlarmTouch: UIView!
    @IBOutlet weak var  gainPTouch: UIView!
    @IBOutlet weak var  gainITouch: UIView!
    @IBOutlet weak var  fanShutdownTouch: UIView!
 

    
//    submenu misc
    @IBOutlet weak var push_firmware: UILabel!
    @IBOutlet weak var push_firmwareValue: UILabel!
    @IBOutlet weak var push_firmwareTouch: UIView!
    
    
    
    @IBOutlet weak var readonly: UILabel!
    @IBOutlet weak var ignition: UILabel!
    @IBOutlet weak var general_header: UILabel!
    @IBOutlet weak var misc_header: UILabel!
    
    
    var f11Values: [String:String] = [:]
    
    var ignitionValues:[String:String]!
    var augerValues:[String:String]!
    var cleaningValues:[String:String]!
    var boilerValues:[String:String]!
    var fanValues:[String:String]!
    var tempUnit:String = "C"
    
    @IBOutlet weak var lockbtn: UIButton!
    @IBOutlet var gradient: gradient!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gradient.installGradientwithvounds(frame: self.view.bounds)
        self.gradient.updateGradient(frame: self.view.bounds)
        settext()
        close()
        let oneFingerTap = UITapGestureRecognizer(target: self, action:#selector(self.oneFingerTapDetected(sender:)))
        oneFingerTap.numberOfTapsRequired = 1
        lockbtn.addGestureRecognizer(oneFingerTap)
        disable()
        
        concurrentQueue.async(flags:.barrier) {
            self.getF11Values()
        }

        
//        concurrentQueue.async(flags:.barrier){
//
//            self.getvaluesFromController(key: "ignition.*")
//        }
//        concurrentQueue.async(flags:.barrier){
//            self.getvaluesFromController(key: "auger.*")
//            
//        }
//        concurrentQueue.async(flags:.barrier){
//            self.getvaluesFromController(key: "cleaning.*")
//            
//        }
//        concurrentQueue.async(flags:.barrier){
//            self.getvaluesFromController(key: "boiler.*")
//            
//        }
//        concurrentQueue.async(flags:.barrier){
//
//            self.getvaluesFromController(key: "fan.*")
//        }


        // Do any additional setup after loading the view.
    }
    @objc func oneFingerTapDetected(sender:UITapGestureRecognizer) {
//        print("call")
         if(ControllerconnectionImpl.getInstance().getController().getSerial() == "12345")
                {
        
                }else
                {
                    self.lockbtn.setTitle("", for: .normal)
                    enable()
                }
       }
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func getF11Values(){
        
        ControllerconnectionImpl.getInstance().requestF11Identified
        {
            (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing")){
                print("f11values error")
            }
            else{
                self.updateUIValues()
            }
        }
    }
    
    func updateUIValues(){
        self.f11Values = ControllerconnectionImpl.getInstance().getFrontData()
        self.setShaftAlarmTempUnit()
        self.PowerIgnitionValue.text = self.f11Values[general.ignition_heat] ?? "-"
        self.PowerIgnitionOperationValue.text = self.f11Values[general.operation_heat] ?? "-"
        self.shutdownTimeValue.text = self.f11Values[general.shutdown_time] ?? "-"
        self.screenLockTimeValue.text = Util.GetDefaultsString(key: general.screen_lock_time) == "nothing" ? "10" : Util.GetDefaultsString(key: general.screen_lock_time)
        self.shaftAlarmValue.text = self.f11Values[general.shaft_alarm] ?? "-"
        self.gainPValue.text = self.f11Values[general.gain_p] ?? "-"
        self.gainIValue.text = self.f11Values[general.gain_i] ?? "-"
        self.fanShutdownValue.text = self.f11Values[general.fan_shutdown] ?? "-"
    }
    
    func setShaftAlarmTempUnit(){
        self.tempUnit = Int(f11Values[misc.temp_unit] ?? "0") == 1 ? "F" : "C"
        self.shaftAlarmLbl.text=Language.getInstance().getlangauge(key: "Shaft_alarm") + "(°\(self.tempUnit))"
    }

    func getvaluesFromController(key:String)  {
        var progress: MBProgressHUD!
        DispatchQueue.main.async {

             progress=Util.showDialog(view: self.view, label: Language.getInstance().getlangauge(key: "please_wait"))
        }
        ControllerconnectionImpl.getInstance().requestRead(key: key) { (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                DispatchQueue.main.async {

                    progress.hide(animated: true)
                }
            }else
            {
                DispatchQueue.main.async {
                    progress.hide(animated: true)
                }
                DispatchQueue.main.async {
                    
                    if(key == "ignition.*")
                    {
                        self.ignitionValues=ControllerResponseImpl.GetReadValue()
                        self.PowerIgnitionValue.text=self.ignitionValues["pellets"]! + "sec"
                        self.PowerIgnitionOperationValue.text=ControllerconnectionImpl.getInstance().getFrontData()[IControllerConstants.shaftTemp]! + "°C"
                     
                    }else if(key == "auger.*")
                    {
                        self.augerValues=ControllerResponseImpl.GetReadValue()
                        self.shutdownTimeValue.text=self.augerValues["auger_10"]! + "%"
                        self.shaftAlarmValue.text=self.augerValues["auger_50"]! + "%"
                        self.gainPValue.text=self.augerValues["auger_100"]! + "%"
                    }else if(key == "cleaning.*")
                    {
                        self.cleaningValues=ControllerResponseImpl.GetReadValue()
                        self.gainIValue.text=self.cleaningValues["valve_time"]! + "°C"
                        self.fanShutdownValue.text=self.cleaningValues["pellets_stop"]! + "°C"
                       
                        
                    }else if(key == "boiler.*")
                    {
                        
                        self.boilerValues=ControllerResponseImpl.GetReadValue()
                      
                    }else if(key == "fan.*")
                    {
                        self.fanValues=ControllerResponseImpl.GetReadValue()
                        
                        //                    self.getvaluesFromController(key: "fan.*")
                    }
                }
                
            }
        }
    }
    func settext()  {
        readonly.text=Language.getInstance().getlangauge(key: "setting_readOnly")
        ignition.text=Language.getInstance().getlangauge(key: "ignition_header")
        general_header.text=Language.getInstance().getlangauge(key: "General")
       
        misc_header.text=Language.getInstance().getlangauge(key: "misc")
        
        setShaftAlarmTempUnit()
        
//        submenu
        PowerIgnitionLbl.text=Language.getInstance().getlangauge(key: "power_duration_ignition") + "(%)"
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.PowerIgnitionTouchFunction(_:)))
        PowerIgnitionTouch.addGestureRecognizer(tap)
        
        PowerIgnitionOperationLbl.text=Language.getInstance().getlangauge(key: "power_duration_operation")
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.PowerIgnitionOperationTouchFunction(_:)))
        PowerIgnitionOperationTouch.addGestureRecognizer(tap1)
//        PowerOperationTouch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.shaftValueTouch(_:))))
       
        
        shutdownTimeLbl.text=Language.getInstance().getlangauge(key: "shutdown_time") + "(s)"
        shutdownTimeTouch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.shutdownTimeTouchFunction(_:))))
        screenLockTimeLbl.text=Language.getInstance().getlangauge(key: "screen_lock")
        screenLockTimeTouch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.screenLockTimeTouchFunction(_:))))
        shaftAlarmTouch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.shaftAlarmTouchFunction(_:))))
        gainPLbl.text=Language.getInstance().getlangauge(key: "Gain_P")
        gainPTouch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.gainPTouchFunction(_:))))
        gainILbl.text=Language.getInstance().getlangauge(key: "Gain_I")
        gainITouch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.gainITouchFunction(_:))))
        fanShutdownLbl.text=Language.getInstance().getlangauge(key: "Fan_shutdown") + "(%)"
        fanShutdownTouch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.fanShutdownTouchFunction(_:))))
        
        push_firmware.text=Language.getInstance().getlangauge(key: "push_firmware")
        push_firmwareTouch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.push_firmwareTouch(_:))))
        
    }
    @IBAction func finish(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func ignitionplus(_ sender: UIButton) {
        if(ignition_sub.isHidden == true)
        {        close()

            sender.setTitle("-", for: .normal)
            ignition_sub.isHidden=false
        }else
        {        close()

            sender.setTitle("+", for: .normal)
            ignition_sub.isHidden=true
        }
    }
    @IBAction func generalPlus(_ sender: UIButton) {
        
        if(general_sub.isHidden == true)
        {        close()

            sender.setTitle("-", for: .normal)
            general_sub.isHidden=false
        }else
        {        close()

            sender.setTitle("+", for: .normal)
            general_sub.isHidden=true
        }
    }
   
    @IBAction func miscPlus(_ sender: UIButton) {
        
        if(misc_sub.isHidden)
        {
            close()
            sender.setTitle("-", for: .normal)
            misc_sub.isHidden=false
        }else
        {
            close()
            sender.setTitle("+", for: .normal)
            misc_sub.isHidden=true
        }
    }
    
    func close()  {
        ignition_sub.isHidden=true
        general_sub.isHidden=true
        misc_sub.isHidden=true
        
        
        ignition_button.setTitle("+", for: .normal)
        general_button.setTitle("+", for: .normal)
        misc_button.setTitle("+", for: .normal)
        
    }
    

    func disable()  {
        
        PowerIgnitionTouch.isUserInteractionEnabled=false
        PowerIgnitionOperationTouch.isUserInteractionEnabled=false
       
        shutdownTimeTouch.isUserInteractionEnabled=false
        screenLockTimeTouch.isUserInteractionEnabled=false
        shaftAlarmTouch.isUserInteractionEnabled=false
        gainPTouch.isUserInteractionEnabled=false
        gainITouch.isUserInteractionEnabled=false
        fanShutdownTouch.isUserInteractionEnabled=false
        
        push_firmwareTouch.isUserInteractionEnabled=false
        ignition_sub.alpha=0.4
        general_sub.alpha=0.4
        misc_sub.alpha=0.4
    }
    func enable() {

         PowerIgnitionTouch.isUserInteractionEnabled=true
        PowerIgnitionOperationTouch.isUserInteractionEnabled=true
         shutdownTimeTouch.isUserInteractionEnabled=true
         screenLockTimeTouch.isUserInteractionEnabled=true
         shaftAlarmTouch.isUserInteractionEnabled=true
         gainPTouch.isUserInteractionEnabled=true
         gainITouch.isUserInteractionEnabled=true
         fanShutdownTouch.isUserInteractionEnabled=true
         
         push_firmwareTouch.isUserInteractionEnabled=true
        ignition_sub.alpha=1
        general_sub.alpha=1
        misc_sub.alpha=1

    }
    
//    @IBAction func lockunlock(_ sender: UIButton) {
//        if(ControllerconnectionImpl.getInstance().getController().getSerial() == "12345")
//        {
//
//        }else
//        {
//            sender.setTitle("", for: .normal)
//            enable()
//        }
//    }
    
    @objc func PowerIgnitionTouchFunction(_ sender:UITapGestureRecognizer)
    {
//        print("ElectricignitionfuelTouch")
        currentvaluechanging=PowerIgnitionValue
        getMinMax(Key: general.ignition_heat, currentValue: PowerIgnitionValue.text!)
    }
    @objc func PowerIgnitionOperationTouchFunction(_ sender:UITapGestureRecognizer )
    {
        print("PowerIgnitionOperationTouchFunction")
        currentvaluechanging=PowerIgnitionOperationValue
        getMinMax(Key: general.operation_heat, currentValue: PowerIgnitionOperationValue.text!)

    }
    
    @objc func shutdownTimeTouchFunction(_ sender:UITapGestureRecognizer)
    {
        currentvaluechanging=shutdownTimeValue
        getMinMax(Key: general.shutdown_time, currentValue: shutdownTimeValue.text!)

    }
    
    @objc func screenLockTimeTouchFunction(_ sender:UITapGestureRecognizer)
    {
        currentvaluechanging=screenLockTimeValue
        let map = ["screen_lock_time":"5,300"]
        self.buildDialogue(map: map, payload: general.screen_lock_time, currentValue: screenLockTimeValue.text!, true)
    }
    
    @objc func shaftAlarmTouchFunction(_ sender:UITapGestureRecognizer )
    {
        
        currentvaluechanging=shaftAlarmValue
        getMinMax(Key: general.shaft_alarm, currentValue: shaftAlarmValue.text!)
    }
    @objc func gainPTouchFunction(_ sender:UITapGestureRecognizer )
    {
        currentvaluechanging=gainPValue
        getMinMax(Key: general.gain_p, currentValue: gainPValue.text!)
        
    }
    @objc func gainITouchFunction(_ sender:UITapGestureRecognizer )
    {
        
        currentvaluechanging=gainIValue
        getMinMax(Key: general.gain_i, currentValue: gainIValue.text!)
    }
    @objc func fanShutdownTouchFunction(_ sender:UITapGestureRecognizer )
    {
        
        currentvaluechanging=fanShutdownValue
        getMinMax(Key: general.fan_shutdown, currentValue: fanShutdownValue.text!)
    }
    
    
    
    
    @objc func electric_ignition_Touch(_ sender:UITapGestureRecognizer )
    {
//        open manual screen
//        print(Util.getWiFiSsid()!)
        
//        print(Util.GetSSID())
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "ManualViewController") as? ManualViewController else { return}
        sVC.modalPresentationStyle = .fullScreen
              self.present(sVC, animated: true)
    }
    @objc func push_firmwareTouch(_ sender:UITapGestureRecognizer )
    {
//        open push firmware screen
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "FirmwareUpdateViewController") as? FirmwareUpdateViewController else { return}
             sVC.modalPresentationStyle = .fullScreen
                   self.present(sVC, animated: true)
    }
    
    
    var currentvaluechanging:UILabel!
    func getMinMax(Key:String,currentValue:String)
    {
        let progress = Util.showDialog(view: self.view, label: Language.getInstance().getlangauge(key: "please_wait"))
        ControllerconnectionImpl.getInstance().requestMinMax(key: Key)
        {
            (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                progress.hide(animated: true)
            }else
            {
                
                progress.hide(animated: true)
                let map = ControllerResponseImpl.getMinMaxValue()
                self.buildDialogue(map: map, payload: Key, currentValue: currentValue)
                
            }
        }
    }
    
    func buildDialogue(map:[String:String],payload:String,currentValue:String, _ localSave: Bool? = false)
    {
        let mapvalue=payload.split(separator: ".")[1]
        var values=map[String(mapvalue)]?.split(separator: ",")
        
        let min = String(values![0])
        let max = String(values![1])
        
        print(min + " : " + max)
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "MinMaxDialougeViewController") as?
            MinMaxDialougeViewController else { return}
        sVC.modalPresentationStyle = .custom
        sVC.modalTransitionStyle = .crossDissolve
        if localSave != nil {
          sVC.saveInternally = localSave!
        }
        sVC.delegate=self
        sVC.minimunValue=min
        sVC.maximumValue=max
        sVC.CurrentValue=currentValue
        sVC.payload=payload
        self.present(sVC, animated: true)
        

    }
    func setMinMAx(key:String,value:String) {
        ControllerconnectionImpl.getInstance().requestSet(key: key, value: value, encryptionMode: "-") { (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                
            }else
            {
                self.currentvaluechanging.text=value
            }
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
