//
//  BBQAdjustmentViewController.swift
//  BBQ
//
//  Created by ps on 29/03/2021.
//  Copyright © 2021 nbe. All rights reserved.
//

import UIKit
import MBProgressHUD


class HomeViewController: UIViewController {
    let concurrentQueue = DispatchQueue(label: "BBQ Adjust Queue", attributes: .concurrent)
    let serialQueue = DispatchQueue(label: "BBQ Serial Queue")
    var serial:String!
    var password:String!
    var fromSplash:Bool!
    var justlangChange:Bool = false
    var f11Values: [String:String] = [:]
    
    @IBOutlet weak var gradient: gradient!
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
    
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
                
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (Timer) in
            print("timer getf11Values")
            self.concurrentQueue.async {
                self.getf11Values()
            }
        })
    }
    
    
    func setupUI(){
            self.setupAllSliders()
            self.setupStatusArea()
            self.setupAllLabels()

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
    
    func setupAllLabels(){
        bbqTemp1Lbl.text = f11Values[Values.bbq_temperature_1] ?? "50"
        meatTemp1Lbl.text = f11Values[Values.meat_temperature_1] ?? "50"
        meatTemp2Lbl.text = f11Values[Values.meat_temperature_2] ?? "50"
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
        if #available(iOS 13.0, *) {
            if let image = UIImage(systemName: "bubble.middle.bottom"){
                slider.setThumbImage(image)
            }
        } else {}
        slider.setThumbColor(.red)
        slider.setTrackColor(.red)
    }
    
    func getf11Values(){
        
        ControllerconnectionImpl.getInstance().getController().setSerial(serial: Util.GetDefaultsString(key: Constants.serialKey))
        ControllerconnectionImpl.getInstance().getController().setPassword(password: Util.GetDefaultsString(key: Constants.passwordKey))
        ControllerconnectionImpl.getInstance().getController().SetIp(ip: Controller.CONTROLLER_DEFAULT_IP)

        ControllerconnectionImpl.getInstance().requestF11Identified
            {
                (ControllerResponseImpl) in
                if(ControllerResponseImpl.getPayload().contains("nothing"))
                {
                    print("error")
                    //                self.showToast(message: "TimeOut Error Try Again")
                }
                else
                {
                    self.f11Values = ControllerResponseImpl.getF11Values()
                    self.setupUI()
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

            if(ControllerResponseImpl.getPayload().contains("nothing")){
                print("error")
                DispatchQueue.main.async {
                    loadingNotification.hide(animated: true)
                   // self.getf11Values()
                }
            }
            else
            {
                DispatchQueue.main.async {
                    loadingNotification.hide(animated: true)
                    self.getf11Values()
                }
                
                
            }
        }
        
    }
    
    
    
    @IBAction func fixedTempChanged(_ sender: UISlider) {
        let d=Double(String(sender.value))
        concurrentQueue.async(flags:.barrier) {
            self.setvalue(key: "bbq.fixed_temperature", value: String(format: "%.0f", d!))
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
