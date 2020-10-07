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
    
  
    
    let concurrentQueue = DispatchQueue(label: "SERVICE Queue", attributes: .concurrent)

    @IBOutlet weak var ignition_sub: UIView!
    @IBOutlet weak var auger_sub: UIView!
    @IBOutlet weak var fanspeed_sub: UIView!
    @IBOutlet weak var cleaning_sub: UIView!
    @IBOutlet weak var cosensor_sub: UIView!
    @IBOutlet weak var manual_sub: UIView!
    @IBOutlet weak var misc_sub: UIView!
    
    
    @IBOutlet weak var ignition_button: UIButton!
    @IBOutlet weak var auger_button: UIButton!
    @IBOutlet weak var fanspeed_button: UIButton!
    @IBOutlet weak var cleaning_button: UIButton!
    @IBOutlet weak var cosensor_button: UIButton!
    @IBOutlet weak var manual_button: UIButton!
    @IBOutlet weak var misc_button: UIButton!
    
    
    
//submenu ignition
    @IBOutlet weak var Electricignitionfuel: UILabel!
    @IBOutlet weak var Electricignitioneffect: UILabel!
    @IBOutlet weak var FanLevel1: UILabel!
    @IBOutlet weak var FanLevel2: UILabel!
    @IBOutlet weak var FanLevel3: UILabel!

    @IBOutlet weak var ElectricignitionfuelValue: UILabel!
    @IBOutlet weak var shaftValue: UILabel!
    @IBOutlet weak var ElectricignitioneffectValue: UILabel!
    @IBOutlet weak var FanLevel1Value: UILabel!
    @IBOutlet weak var FanLevel2Value: UILabel!
    @IBOutlet weak var FanLevel3Value: UILabel!
    
    @IBOutlet weak var ElectricignitionfuelTouch: UIView!
    @IBOutlet weak var shaftValueTouch: UIView!
    @IBOutlet weak var ElectricignitioneffectTouch: UIView!
    @IBOutlet weak var Fanlevel1Touch: UIView!
    @IBOutlet weak var Fanlevel2Touch: UIView!
    @IBOutlet weak var Fanlevel3Touch: UIView!
    
//    submenu auger
    @IBOutlet weak var  augerlevel1: UILabel!
    @IBOutlet weak var  augerlevel2: UILabel!
    @IBOutlet weak var  augerlevel3: UILabel!
    @IBOutlet weak var  somkelevel1: UILabel!
    @IBOutlet weak var  somkelevel2: UILabel!
    @IBOutlet weak var  somkelevel3: UILabel!
    @IBOutlet weak var  woodburningtemp: UILabel!
    
    @IBOutlet weak var  augerlevel1Value: UILabel!
    @IBOutlet weak var  augerlevel2Value: UILabel!
    @IBOutlet weak var  augerlevel3Value: UILabel!
    @IBOutlet weak var  somkelevel1Value: UILabel!
    @IBOutlet weak var  somkelevel2Value: UILabel!
    @IBOutlet weak var  somkelevel3Value: UILabel!
    @IBOutlet weak var  woodburningtempValue: UILabel!
    
    @IBOutlet weak var  augerlevel1Touch: UIView!
    @IBOutlet weak var  augerlevel2Touch: UIView!
    @IBOutlet weak var  augerlevel3Touch: UIView!
    @IBOutlet weak var  somkelevel1Touch: UIView!
    @IBOutlet weak var  somkelevel2Touch: UIView!
    @IBOutlet weak var  somkelevel3Touch: UIView!
    @IBOutlet weak var  woodburningtempTouch: UIView!
    
//    submenu fan
    @IBOutlet weak var  fanspeed1: UILabel!
    @IBOutlet weak var  fanspeed2: UILabel!
    @IBOutlet weak var  fanspeed3: UILabel!
    
    @IBOutlet weak var  fanspeed1Value: UILabel!
    @IBOutlet weak var  fanspeed2Value: UILabel!
    @IBOutlet weak var  fanspeed3Value: UILabel!
    
    @IBOutlet weak var  fanspeed1Touch: UIView!
    @IBOutlet weak var  fanspeed2Touch: UIView!
    @IBOutlet weak var  fanspeed3Touch: UIView!
//      submenu cleaning
    @IBOutlet weak var  cleaning_fan_period: UILabel!
    @IBOutlet weak var  cleaning_fan_time: UILabel!
    @IBOutlet weak var  cleaning_fan_speed: UILabel!
    
    @IBOutlet weak var  cleaning_fan_period_value: UILabel!
    @IBOutlet weak var  cleaning_fan_time_value: UILabel!
    @IBOutlet weak var  cleaning_fan_speed_value: UILabel!
    
    
    @IBOutlet weak var  cleaning_fan_period_Touch: UIView!
    @IBOutlet weak var  cleaning_fan_time_Touch: UIView!
    @IBOutlet weak var  cleaning_fan_speed_Touch: UIView!
    //      submenu co sensor
    @IBOutlet weak var  sensor_pressure_t7: UILabel!
    @IBOutlet weak var  sensor_comp_period: UILabel!
    @IBOutlet weak var  sensor_valve_period: UILabel!
    
    @IBOutlet weak var  sensor_pressure_t7Value: UILabel!
    @IBOutlet weak var  sensor_comp_periodValue: UILabel!
    @IBOutlet weak var  sensor_valve_periodValue: UILabel!
    
    
    @IBOutlet weak var  sensor_pressure_t7Touch: UIView!
    @IBOutlet weak var  sensor_comp_periodTouch: UIView!
    @IBOutlet weak var  sensor_valve_periodTouch: UIView!
    
    
//    submenu manual
    
    @IBOutlet weak var electric_ignition_fuel: UILabel!
    @IBOutlet weak var electric_ignition_Touch: UIView!
    
//    submenu misc
    @IBOutlet weak var push_firmware: UILabel!
    @IBOutlet weak var push_firmwareValue: UILabel!
    @IBOutlet weak var push_firmwareTouch: UIView!
    
    
    
    @IBOutlet weak var readonly: UILabel!
    @IBOutlet weak var ignition: UILabel!
    @IBOutlet weak var auger: UILabel!
    @IBOutlet weak var fanspeed: UILabel!
    @IBOutlet weak var cleaning: UILabel!
    @IBOutlet weak var cosensor: UILabel!
    @IBOutlet weak var manual: UILabel!
    @IBOutlet weak var misc: UILabel!
    
    
    var ignitionValues:[String:String]!
    var augerValues:[String:String]!
    var cleaningValues:[String:String]!
    var boilerValues:[String:String]!
    var fanValues:[String:String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        close()
        settext()
        concurrentQueue.async(flags:.barrier){

            self.getvaluesFromController(key: "ignition.*")
        }
        concurrentQueue.async(flags:.barrier){
            self.getvaluesFromController(key: "auger.*")
            
        }
        concurrentQueue.async(flags:.barrier){
            self.getvaluesFromController(key: "cleaning.*")
            
        }
        concurrentQueue.async(flags:.barrier){
            self.getvaluesFromController(key: "boiler.*")
            
        }
        concurrentQueue.async(flags:.barrier){

            self.getvaluesFromController(key: "fan.*")
        }



        // Do any additional setup after loading the view.
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
                if(key == "ignition.*")
                {
                    self.ignitionValues=ControllerResponseImpl.GetReadValue()
                    self.ElectricignitionfuelValue.text=self.ignitionValues["pellets"]! + "sec"
                    self.shaftValue.text=ControllerconnectionImpl.getInstance().getFrontData()[IControllerConstants.shaftTemp]! + "°C"
                    self.ElectricignitioneffectValue.text=self.ignitionValues["power"]! + "%"
                    self.FanLevel1Value.text=self.ignitionValues["fan_10"]! + "%"
                    self.FanLevel2Value.text=self.ignitionValues["fan_50"]! + "%"
                    self.FanLevel3Value.text=self.ignitionValues["fan_100"]! + "%"
                }else if(key == "auger.*")
                {
                    self.augerValues=ControllerResponseImpl.GetReadValue()
                    self.augerlevel1Value.text=self.augerValues["auger_10"]! + "%"
                    self.augerlevel2Value.text=self.augerValues["auger_50"]! + "%"
                    self.augerlevel3Value.text=self.augerValues["auger_100"]! + "%"
                }else if(key == "cleaning.*")
                {
                   self.cleaningValues=ControllerResponseImpl.GetReadValue()
                    self.somkelevel1Value.text=self.cleaningValues["valve_time"]! + "°C"
                    self.somkelevel2Value.text=self.cleaningValues["pellets_stop"]! + "°C"
                    self.somkelevel3Value.text=self.cleaningValues["comp_fan_speed"]! + "°C"
                    
                    self.cleaning_fan_period_value.text=self.cleaningValues["fan_period"]! + "min"
                    self.cleaning_fan_time_value.text=self.cleaningValues["fan_time"]! + "sec"
                    self.cleaning_fan_speed_value.text=self.cleaningValues["fan_speed"]! + "%"
                    
                    
                    self.sensor_pressure_t7Value.text=ControllerconnectionImpl.getInstance().getFrontData()[IControllerConstants.oxygen]
                    self.sensor_comp_periodValue.text=self.cleaningValues["comp_period"]!
                    self.sensor_valve_periodValue.text=self.cleaningValues["valve_period"]!
                    
                }else if(key == "boiler.*")
                {
                    
                    self.boilerValues=ControllerResponseImpl.GetReadValue()
                    self.woodburningtempValue.text=self.boilerValues["min_return"]! + "°C"
                }else if(key == "fan.*")
                {
                    self.fanValues=ControllerResponseImpl.GetReadValue()
                    
                    self.fanspeed1Value.text=self.fanValues["speed_10"]! + "%"
                    self.fanspeed2Value.text=self.fanValues["speed_50"]! + "%"
                    self.fanspeed3Value.text=self.fanValues["speed_100"]! + "%"
//                    self.getvaluesFromController(key: "fan.*")
                }
                
            }
        }
    }
    func settext()  {
        readonly.text=Language.getInstance().getlangauge(key: "setting_readOnly")
        ignition.text=Language.getInstance().getlangauge(key: "ignition_header")
        auger.text=Language.getInstance().getlangauge(key: "smoke_header")
        fanspeed.text=Language.getInstance().getlangauge(key: "fan_header")
        cleaning.text=Language.getInstance().getlangauge(key: "cleaning_header")
        cosensor.text=Language.getInstance().getlangauge(key: "sensor_header")
        manual.text=Language.getInstance().getlangauge(key: "manual_header")
        misc.text=Language.getInstance().getlangauge(key: "misc")
        
        
//        submenu
        Electricignitionfuel.text=Language.getInstance().getlangauge(key: "ignition_pellets") + "(90 sec)"
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.ElectricignitionfuelTouch(_:)))
        ElectricignitionfuelTouch.addGestureRecognizer(tap)
        
        Electricignitioneffect.text=Language.getInstance().getlangauge(key: "ignition_power") + "(75%)"
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.ElectricignitioneffectTouch(_:)))
        ElectricignitioneffectTouch.addGestureRecognizer(tap1)
        shaftValueTouch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.shaftValueTouch(_:))))
        FanLevel1.text=Language.getInstance().getlangauge(key: "ignition_fan_10") + "(100%)"
        Fanlevel1Touch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.Fanlevel1Touch(_:))))
        FanLevel2.text=Language.getInstance().getlangauge(key: "ignition_fan_50") + "(100%)"
        Fanlevel2Touch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.Fanlevel2Touch(_:))))
        FanLevel3.text=Language.getInstance().getlangauge(key: "ignition_fan_100") + "(100%)"
        Fanlevel3Touch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.Fanlevel3Touch(_:))))
        
        
        augerlevel1.text=Language.getInstance().getlangauge(key: "smoke_auger_10") + "(20.0%)"
        augerlevel1Touch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.augerlevel1Touch(_:))))
        augerlevel2.text=Language.getInstance().getlangauge(key: "smoke_auger_50") + "(25.0%)"
        augerlevel2Touch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.augerlevel2Touch(_:))))
        augerlevel3.text=Language.getInstance().getlangauge(key: "smoke_auger_100") + "(40.0%)"
        augerlevel3Touch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.augerlevel3Touch(_:))))
        somkelevel1.text=Language.getInstance().getlangauge(key: "smoke_valve_time") + "(135°C)"
        somkelevel1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.somkelevel1Touch(_:))))
        somkelevel2.text=Language.getInstance().getlangauge(key: "smoke_pellets_stop") + "(175°C)"
        somkelevel2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.somkelevel2Touch(_:))))
        somkelevel3.text=Language.getInstance().getlangauge(key: "smoke_comp_fan_speed") + "(190°C)"
        somkelevel3Touch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.somkelevel3Touch(_:))))
        woodburningtemp.text=Language.getInstance().getlangauge(key: "smoke_min_return") + "(280°C)"
        woodburningtempTouch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.woodburningtempTouch(_:))))
        
        
        fanspeed1.text=Language.getInstance().getlangauge(key: "fan_speed_10") + "(40%)"
        fanspeed1Touch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.fanspeed1Touch(_:))))
        fanspeed2.text=Language.getInstance().getlangauge(key: "fan_speed_50") + "(55%)"
        fanspeed2Touch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.fanspeed2Touch(_:))))
        fanspeed3.text=Language.getInstance().getlangauge(key: "fan_speed_100") + "(80%)"
        fanspeed3Touch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.fanspeed3Touch(_:))))
        
        cleaning_fan_period.text=Language.getInstance().getlangauge(key: "cleaning_fan_period") + "(6 min)"
        cleaning_fan_period_Touch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cleaning_fan_period_Touch(_:))))
        cleaning_fan_time.text=Language.getInstance().getlangauge(key: "cleaning_fan_time") + "(8 sec)"
        cleaning_fan_time_Touch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cleaning_fan_time_Touch(_:))))
        cleaning_fan_speed.text=Language.getInstance().getlangauge(key: "cleaning_fan_speed") + "(100%)"
        cleaning_fan_speed_Touch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cleaning_fan_speed_Touch(_:))))
        
        
        sensor_pressure_t7.text=Language.getInstance().getlangauge(key: "sensor_pressure_t7")
        sensor_pressure_t7Touch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sensor_pressure_t7Touch(_:))))
        sensor_comp_period.text=Language.getInstance().getlangauge(key: "sensor_comp_period") + "(850)"
        sensor_comp_periodTouch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sensor_comp_periodTouch(_:))))
        sensor_valve_period.text=Language.getInstance().getlangauge(key: "sensor_valve_period") + "(900)"
        sensor_valve_periodTouch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sensor_valve_periodTouch(_:))))
        
        
        electric_ignition_fuel.text=Language.getInstance().getlangauge(key: "open_manual_mode")
        electric_ignition_Touch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.electric_ignition_Touch(_:))))
        
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
    @IBAction func augerPlus(_ sender: UIButton) {
        
        if(auger_sub.isHidden == true)
        {        close()

            sender.setTitle("-", for: .normal)
            auger_sub.isHidden=false
        }else
        {        close()

            sender.setTitle("+", for: .normal)
            auger_sub.isHidden=true
        }
    }
    @IBAction func FanSpeedPlus(_ sender: UIButton) {
        if(fanspeed_sub.isHidden)
        {        close()

            sender.setTitle("-", for: .normal)
            fanspeed_sub.isHidden=false
        }else
        {        close()

            sender.setTitle("+", for: .normal)
            fanspeed_sub.isHidden=true
        }
    }
    @IBAction func cleaningPlus(_ sender: UIButton) {
        if(cleaning_sub.isHidden)
        {        close()

            sender.setTitle("-", for: .normal)
            cleaning_sub.isHidden=false
        }else
        {        close()

            sender.setTitle("+", for: .normal)
            cleaning_sub.isHidden=true
        }
    }
    @IBAction func cosensorPlus(_ sender: UIButton) {
        if(cosensor_sub.isHidden)
        {        close()

            sender.setTitle("-", for: .normal)
            cosensor_sub.isHidden=false
        }else
        {        close()

            sender.setTitle("+", for: .normal)
            cosensor_sub.isHidden=true
        }
    }
    @IBAction func manualPlus(_ sender: UIButton) {
        if(manual_sub.isHidden)
        {
            close()

            sender.setTitle("-", for: .normal)
            manual_sub.isHidden=false
        }else
        {
            close()

            sender.setTitle("+", for: .normal)
            manual_sub.isHidden=true
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
        auger_sub.isHidden=true
        fanspeed_sub.isHidden=true
        cleaning_sub.isHidden=true
        cosensor_sub.isHidden=true
        manual_sub.isHidden=true
        misc_sub.isHidden=true
        
        
        ignition_button.setTitle("+", for: .normal)
        auger_button.setTitle("+", for: .normal)
        fanspeed_button.setTitle("+", for: .normal)
        cleaning_button.setTitle("+", for: .normal)
        cosensor_button.setTitle("+", for: .normal)
        manual_button.setTitle("+", for: .normal)
        misc_button.setTitle("+", for: .normal)
        
    }
    

    
    
    @objc func ElectricignitionfuelTouch(_ sender:UITapGestureRecognizer)
    {
//        print("ElectricignitionfuelTouch")
        currentvaluechanging=ElectricignitionfuelValue
        getMinMax(Key: "ignition.pellets", currentValue: ElectricignitionfuelValue.text!)
    }
    @objc func shaftValueTouch(_ sender:UITapGestureRecognizer )
    {
        print("shaftValueTouch")
    }
    @objc func ElectricignitioneffectTouch(_ sender:UITapGestureRecognizer )
    {
        print("ElectricignitioneffectTouch")
        currentvaluechanging=ElectricignitioneffectValue
        getMinMax(Key: "ignition.power", currentValue: ElectricignitioneffectValue.text!)

    }
    @objc func Fanlevel1Touch(_ sender:UITapGestureRecognizer )
    {
        print("Fanlevel1Touch")
        currentvaluechanging=FanLevel1Value
        getMinMax(Key: "ignition.fan_10", currentValue: FanLevel1Value.text!)

    }
    @objc func Fanlevel2Touch(_ sender:UITapGestureRecognizer )
    {
        print("Fanlevel2Touch")
        currentvaluechanging=FanLevel2Value
        getMinMax(Key: "ignition.fan_50", currentValue: FanLevel2Value.text!)
    }
    @objc func Fanlevel3Touch(_ sender:UITapGestureRecognizer )
    {
        print("Fanlevel3Touch")
        currentvaluechanging=FanLevel3Value
        getMinMax(Key: "ignition.fan_100", currentValue: FanLevel3Value.text!)
    }
    
    
    @objc func augerlevel1Touch(_ sender:UITapGestureRecognizer)
    {
        currentvaluechanging=augerlevel1Value
        getMinMax(Key: "auger.auger_10", currentValue: augerlevel1Value.text!)

    }
    @objc func augerlevel2Touch(_ sender:UITapGestureRecognizer )
    {
        
        currentvaluechanging=augerlevel2Value
        getMinMax(Key: "auger.auger_50", currentValue: augerlevel2Value.text!)
    }
    @objc func augerlevel3Touch(_ sender:UITapGestureRecognizer )
    {
        currentvaluechanging=augerlevel3Value
        getMinMax(Key: "auger.auger_100", currentValue: augerlevel3Value.text!)
        
    }
    @objc func somkelevel1Touch(_ sender:UITapGestureRecognizer )
    {
        
        currentvaluechanging=somkelevel1Value
        getMinMax(Key: "cleaning.valve_time", currentValue: somkelevel1Value.text!)
    }
    @objc func somkelevel2Touch(_ sender:UITapGestureRecognizer )
    {
        
        currentvaluechanging=somkelevel2Value
        getMinMax(Key: "cleaning.pellets_stop", currentValue: somkelevel2Value.text!)
    }
    @objc func somkelevel3Touch(_ sender:UITapGestureRecognizer )
    {
        
        currentvaluechanging=somkelevel3Value
        getMinMax(Key: "cleaning.comp_fan_speed", currentValue: somkelevel3Value.text!)
    }
    @objc func woodburningtempTouch(_ sender:UITapGestureRecognizer )
    {
        currentvaluechanging=woodburningtempValue
        getMinMax(Key: "boiler.min_return", currentValue: woodburningtempValue.text!)

    }
    
    
    
    @objc func fanspeed1Touch(_ sender:UITapGestureRecognizer )
    {
        currentvaluechanging=fanspeed1Value
        getMinMax(Key: "fan.speed_10", currentValue: fanspeed1Value.text!)
        
    }
    @objc func fanspeed2Touch(_ sender:UITapGestureRecognizer )
    {
        
        currentvaluechanging=fanspeed2Value
        getMinMax(Key: "fan.speed_50", currentValue: fanspeed2Value.text!)
    }
    @objc func fanspeed3Touch(_ sender:UITapGestureRecognizer )
    {
        currentvaluechanging=fanspeed3Value
        getMinMax(Key: "fan.speed_100", currentValue: fanspeed3Value.text!)
        
    }
    
    
    
    @objc func cleaning_fan_period_Touch(_ sender:UITapGestureRecognizer )
    {
        
        currentvaluechanging=cleaning_fan_period_value
        getMinMax(Key: "cleaning.fan_period", currentValue: cleaning_fan_period_value.text!)
    }
    @objc func cleaning_fan_time_Touch(_ sender:UITapGestureRecognizer )
    {
        
        currentvaluechanging=cleaning_fan_time_value
        getMinMax(Key: "cleaning.fan_time", currentValue: cleaning_fan_time_value.text!)
    }
    @objc func cleaning_fan_speed_Touch(_ sender:UITapGestureRecognizer )
    {
        
        currentvaluechanging=cleaning_fan_speed_value
        getMinMax(Key: "cleaning.fan_speed", currentValue: cleaning_fan_speed_value.text!)
    }
    
    
    
    @objc func sensor_pressure_t7Touch(_ sender:UITapGestureRecognizer )
    {
        
    }
    @objc func sensor_comp_periodTouch(_ sender:UITapGestureRecognizer )
    {
        currentvaluechanging=sensor_comp_periodValue
        getMinMax(Key: "cleaning.comp_period", currentValue: sensor_comp_periodValue.text!)
    }
    @objc func sensor_valve_periodTouch(_ sender:UITapGestureRecognizer )
    {
        currentvaluechanging=sensor_valve_periodValue
        getMinMax(Key: "cleaning.valve_period", currentValue: sensor_valve_periodValue.text!)
    }

    
    @objc func electric_ignition_Touch(_ sender:UITapGestureRecognizer )
    {
//        open manual screen
        print(Util.getWiFiSsid()!)
        
        print(Util.GetSSID())
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "ManualViewController") as? ManualViewController else { return}
              self.present(sVC, animated: true)
    }
    @objc func push_firmwareTouch(_ sender:UITapGestureRecognizer )
    {
//        open push firmware screen
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
    
    func buildDialogue(map:[String:String],payload:String,currentValue:String)
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
