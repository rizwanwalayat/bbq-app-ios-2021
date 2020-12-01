//
//  AdjustmentViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 24/07/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit
import MBProgressHUD

class AdjustmentViewController: UIViewController {

    let concurrentQueue = DispatchQueue(label: "adjust Queue", attributes: .concurrent)

    @IBOutlet weak var fan1Layout: MyCustomView!
    @IBOutlet weak var fan2Layout: MyCustomView!
    @IBOutlet weak var fan3Layout: MyCustomView!
    
    @IBOutlet weak var auger1Layout: MyCustomView!
    @IBOutlet weak var auger2Layout: MyCustomView!
    @IBOutlet weak var auger3Layout: MyCustomView!
    
    
    @IBOutlet weak var fanText1: UILabel!
    @IBOutlet weak var fantext2: UILabel!
    @IBOutlet weak var fanText3: UILabel!
    
    @IBOutlet weak var augerText1: UILabel!
    @IBOutlet weak var augerText2: UILabel!
    @IBOutlet weak var augertext3: UILabel!
    
    
    @IBOutlet weak var sliderFan1: UISlider!
    @IBOutlet weak var sliderFan2: UISlider!
    @IBOutlet weak var sliderFan3: UISlider!
    
    
    @IBOutlet weak var sliderAuger1: UISlider!
    @IBOutlet weak var sliderAuger2: UISlider!
    @IBOutlet weak var sliderAuger3: UISlider!
    
    @IBOutlet weak var prominentText: UILabel!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var mainText2: UILabel!
    @IBOutlet weak var maintext3: UILabel!
    
    @IBOutlet weak var resetButtonLabel: UIButton!
    var fan : [String:String]!
    var auger : [String:String]!
    @IBOutlet var gradient: gradient!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gradient.installGradientwithvounds(frame: self.view.bounds)

        self.gradient.updateGradient(frame: self.view.bounds)
        disable()

        fanText1.text=Language.getInstance().getlangauge(key: "fan_header")
        fantext2.text=Language.getInstance().getlangauge(key: "fan_header")
        fanText3.text=Language.getInstance().getlangauge(key: "fan_header")
        augerText1.text=Language.getInstance().getlangauge(key: "pellets")
        augerText2.text=Language.getInstance().getlangauge(key: "pellets")
        augertext3.text=Language.getInstance().getlangauge(key: "pellets")
        resetButtonLabel.setTitle(Language.getInstance().getlangauge(key: "setting_alarmStop"), for: .normal)
        concurrentQueue.async(flags:.barrier) {
            self.getfanValue(callAuger: true)
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {

    }
    func getfanValue(callAuger:Bool)  {
        ControllerconnectionImpl.getInstance().requestRead(key: "fan.*") { (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                
            }
            else
            {
                self.fan=ControllerResponseImpl.GetReadValue()
                if(callAuger)
                {
                    self.concurrentQueue.async(flags:.barrier) {
                        self.getaugerValue()
                    }
                }else
                {
                    self.updateUI()
                }
            }
        }
    }
    
    func getaugerValue()  {
        ControllerconnectionImpl.getInstance().requestRead(key: "auger.*") { (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                
            }
            else
            {
                self.auger=ControllerResponseImpl.GetReadValue()
                DispatchQueue.main.async {
                    self.updateUI()
                }
                
            }
        }
    }
    func updateUI()  {
        
        mainText.text=Language.getInstance().getlangauge(key: "heat_level_1")
        mainText2.text=Language.getInstance().getlangauge(key: "heat_level_2")
        maintext3.text=Language.getInstance().getlangauge(key: "heat_level_3")
        
        resetButtonLabel.setTitle(Language.getInstance().getlangauge(key: "setting_alarmStop"), for: .normal)
        resetButtonLabel.isEnabled=false
//        print(fan)
        sliderFan1.setValue(getFloatValue(value: fan["speed_10"]!), animated: true)
        sliderFan2.setValue(getFloatValue(value: fan["speed_50"]!), animated: true)
        sliderFan3.setValue(getFloatValue(value: fan["speed_100"]!), animated: true)
        fanText1.text=Language.getInstance().getlangauge(key: "fan_header") + "( " + fan["speed_10"]! + " %)"
        fantext2.text=Language.getInstance().getlangauge(key: "fan_header") + "( " + fan["speed_50"]! + " %)"
        fanText3.text=Language.getInstance().getlangauge(key: "fan_header") + "( " + fan["speed_100"]! + " %)"
//        print(auger)
        
        //TODO
//        sliderAuger1
        sliderAuger2.setValue(getFloatValue(value: auger["auger_50"]!), animated: true)
        sliderAuger3.setValue(getFloatValue(value: auger["auger_100"]!), animated: true)
        augerText1.text=Language.getInstance().getlangauge(key: "pellets") + "( " + auger["auger_10"]! + " %)"
        augerText2.text=Language.getInstance().getlangauge(key: "pellets") + "( " + auger["auger_50"]! + " %)"
        augertext3.text=Language.getInstance().getlangauge(key: "pellets") + "( " + auger["auger_100"]! + " %)"

    }
    
    func getFloatValue(value:String) -> Float {
        
        return (value as NSString).floatValue
    }
    
    func disable()  {
        
        
        sliderFan1.isUserInteractionEnabled=false
        sliderFan2.isUserInteractionEnabled=false
        sliderFan3.isUserInteractionEnabled=false
        sliderAuger1.isUserInteractionEnabled=false
        sliderAuger2.isUserInteractionEnabled=false
        sliderAuger3.isUserInteractionEnabled=false
        fan1Layout.alpha=0.4
        fan2Layout.alpha=0.4
        fan3Layout.alpha=0.4
        auger1Layout.alpha=0.4
        auger2Layout.alpha=0.4
        auger3Layout.alpha=0.4
        
    }
    func enable()  {
        
        sliderFan1.isUserInteractionEnabled=true
        sliderFan2.isUserInteractionEnabled=true
        sliderFan3.isUserInteractionEnabled=true
        sliderAuger1.isUserInteractionEnabled=true
        sliderAuger2.isUserInteractionEnabled=true
        sliderAuger3.isUserInteractionEnabled=true
        fan1Layout.alpha=1
        fan2Layout.alpha=1
        fan3Layout.alpha=1
        auger1Layout.alpha=1
        auger2Layout.alpha=1
        auger3Layout.alpha=1
        resetButtonLabel.isEnabled=true
        
    }
    
    
    @IBAction func lockUnlcok(_ sender: UIButton) {
        sender.setTitle("", for: .normal)
        enable()
    }
    
    
    @IBAction func finish(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func fanslider1end(_ sender: UISlider) {
        prominentText.text=""
        let d=Double(String((sender as! UISlider).value))
        concurrentQueue.async(flags:.barrier) {

            self.setvalue(key: "fan.speed_10", value: String(format: "%.0f", d!))
        }
    }
    
    
    @IBAction func fanslider2end(_ sender: UISlider) {
        
        prominentText.text=""
        let d=Double(String((sender as! UISlider).value))
        concurrentQueue.async(flags:.barrier) {
            self.setvalue(key: "fan.speed_50", value: String(format: "%.0f", d!))

        }
    }
    
    @IBAction func fanslider3end(_ sender: UISlider) {
        
        prominentText.text=""
        let d=Double(String((sender as! UISlider).value))
        concurrentQueue.async(flags:.barrier) {
            self.setvalue(key: "fan.speed_100", value: String(format: "%.0f", d!))
        }
    }
    
    @IBAction func augerslider1end(_ sender: UISlider) {
        
        prominentText.text=""
        let d=Double(String((sender as! UISlider).value))
        concurrentQueue.async(flags:.barrier) {
            self.setvalue(key: "auger.auger_10", value: String(format: "%.2f", d!))
        }
    }
    @IBAction func augerslide2end(_ sender: UISlider) {
        
        prominentText.text=""
        let d=Double(String((sender as! UISlider).value))
        concurrentQueue.async(flags:.barrier) {
            self.setvalue(key: "auger.auger_50", value: String(format: "%.0f", d!))
        }
    }
    
    @IBAction func augerslider3end(_ sender: UISlider) {
        
        prominentText.text=""
        let d=Double(String((sender as! UISlider).value))
        concurrentQueue.async(flags:.barrier) {
            self.setvalue(key: "auger.auger_100", value: String(format: "%.0f", d!))
        }
    }
    
    func setvalue(key:String,value:String) {
        
        var loadingNotification : MBProgressHUD!
             DispatchQueue.main.async {
                 loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                 loadingNotification.mode = MBProgressHUDMode.indeterminate
                 loadingNotification.label.text = Language.getInstance().getlangauge(key: "loading")
                 loadingNotification.detailsLabel.text = Language.getInstance().getlangauge(key:"please_wait")
                  }
        
        ControllerconnectionImpl.getInstance().requestSet(key: key, value: value, encryptionMode: " ") { (ControllerResponseImpl) in
            DispatchQueue.main.async {
                                        loadingNotification.hide(animated: true)
                                    }
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                
            }
            else
            {
                if(key.contains("fan"))
                {
                    self.concurrentQueue.async(flags:.barrier) {
                        self.getfanValue(callAuger: false)
                    }
                }else
                {
                    self.concurrentQueue.async(flags:.barrier) {
                        self.getaugerValue()
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func fanslider1start(_ sender: UISlider) {
         let d=Double(String((sender as! UISlider).value))
        prominentText.text="Fan 1 :  " + String(format: "%.0f", d!)
        
    }
    
    @IBAction func fanslider2start(_ sender: UISlider) {
        
        let d=Double(String((sender as! UISlider).value))
        prominentText.text="Fan 2 :  " + String(format: "%.0f", d!)
    }
    @IBAction func fanslider3start(_ sender: UISlider) {
        
        let d=Double(String((sender as! UISlider).value))
        prominentText.text="Fan 3 :  " + String(format: "%.0f", d!)
    }
    @IBAction func augerslider1start(_ sender: UISlider) {
        
        let d=Double(String((sender as! UISlider).value))
        prominentText.text="Auger 1 :  " + String(format: "%.2f", d!)
    }
    
    @IBAction func augerslider2start(_ sender: UISlider) {
        
        let d=Double(String((sender as! UISlider).value))
        prominentText.text="Auger 2 :  " + String(format: "%.0f", d!)
    }
    @IBAction func augerslider3start(_ sender: UISlider) {
        
        let d=Double(String((sender as! UISlider).value))
        prominentText.text="Auger 3 :  " + String(format: "%.0f", d!)
    }
  
    
    @IBAction func reset(_ sender: UIButton) {
        
        dialogFunction()
//        setDefaultValue(key: "fan.speed_10", Value: "18")
    }
    
    func dialogFunction()  {
        let alert = UIAlertController(title: "", message: Language.getInstance().getlangauge(key: "reset_alert"), preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: Language.getInstance().getlangauge(key: "cancel"), style: UIAlertAction.Style.default, handler: { _ in
                  //Cancel Action
            print("cancel press")
              }))
              alert.addAction(UIAlertAction(title: Language.getInstance().getlangauge(key: "ok"),
                                            style: UIAlertAction.Style.destructive,
                                            handler: {(_: UIAlertAction!) in
                                              //Sign out action
                                                self.resetall()
              }))
              self.present(alert, animated: true, completion: nil)
    }
    
    func resetall()  {
        
        concurrentQueue.async(flags:.barrier) {
                   self.setvalue(key: "fan.speed_10", value:"40")
               }
        concurrentQueue.async(flags:.barrier) {
                         self.setvalue(key: "fan.speed_50", value:"50")
                     }
        concurrentQueue.async(flags:.barrier) {
                         self.setvalue(key: "fan.speed_100", value:"80")
                     }
        concurrentQueue.async(flags:.barrier) {
                         self.setvalue(key: "auger.auger_10", value:"20")
                     }
        concurrentQueue.async(flags:.barrier) {
                         self.setvalue(key: "auger.auger_50", value:"25")
                     }
        concurrentQueue.async(flags:.barrier) {
                         self.setvalue(key: "auger.auger_100", value:"40")
                     }
    }
    
    func setDefaultValue(key:String,Value:String)
    {
//        if(key == "fan.speed_10")
//        {
//
//        }else if(key == "fan.speed_50")
//        {
//
//        }else if(key == "fan.speed_100")
//        {
//
//        }else if(key == "auger.auger_10")
//        {
//
//        }else if(key == "auger.auger_50")
//        {
//
//        }else if(key == "auger.auger_100")
//        {
//
//        }
        ControllerconnectionImpl.getInstance().requestSet(key: key, value: Value, encryptionMode: " ") { (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                
            }else
            {
                if(key == "fan.speed_10")
                {
                    self.setDefaultValue(key: "fan.speed_50", Value: "24")
                }else if(key == "fan.speed_50")
                {
                    
                    self.setDefaultValue(key: "fan.speed_100", Value: "80")
                }else if(key == "fan.speed_100")
                {
                    self.setDefaultValue(key: "auger.auger_10", Value: "20")
                    
                }else if(key == "auger.auger_10")
                {
                    
                    self.setDefaultValue(key: "auger.auger_50", Value: "25")
                }else if(key == "auger.auger_50")
                {
                    
                    self.setDefaultValue(key: "auger.auger_100", Value: "40")
                }else if(key == "auger.auger_100")
                {
                    self.getfanValue(callAuger: true)
                }
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
