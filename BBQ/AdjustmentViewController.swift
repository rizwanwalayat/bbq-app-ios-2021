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
    var f11Values: [String: String] = [:]
    
    // MARK:- Custom Sliders
    
    @IBOutlet weak var feedLowSlider: CustomSlider!
    @IBOutlet weak var feedHighSlider: CustomSlider!
    @IBOutlet weak var fanLowSlider: CustomSlider!
    @IBOutlet weak var fanHighSlider: CustomSlider!
    @IBOutlet weak var smokeFeedSlider: CustomSlider!
    @IBOutlet weak var smokeFanSlider: CustomSlider!
    @IBOutlet weak var smokePauseSlider: CustomSlider!
    
    
    
    @IBOutlet weak var fan1Layout: MyCustomView!
    
    
    @IBOutlet weak var resetButtonLabel: UIButton!
    var fan : [String:String]!
    var auger : [String:String]!
    @IBOutlet var gradient: gradient!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUIValues()
        

        
        concurrentQueue.async(flags:.barrier) {
            self.getF11Values()
        }
        
        
        //        self.gradient.installGradientwithvounds(frame: self.view.bounds)
        //
        //        self.gradient.updateGradient(frame: self.view.bounds)
        
//        disable()
//
//        fanText1.text=Language.getInstance().getlangauge(key: "fan_header")
//        fantext2.text=Language.getInstance().getlangauge(key: "fan_header")
//        fanText3.text=Language.getInstance().getlangauge(key: "fan_header")
//        augerText1.text=Language.getInstance().getlangauge(key: "pellets")
//        augerText2.text=Language.getInstance().getlangauge(key: "pellets")
//        augertext3.text=Language.getInstance().getlangauge(key: "pellets")
//        resetButtonLabel.setTitle(Language.getInstance().getlangauge(key: "setting_alarmStop"), for: .normal)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {

    }
    
    func updateUIValues(){
        self.f11Values = ControllerconnectionImpl.getInstance().getFrontData()
        print("f11Values", self.f11Values)
        self.updateAllSliders()
    }
    
    func getF11Values(){
        
        ControllerconnectionImpl.getInstance().requestF11Identified
        {
            (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing")){
                print("f11values error")
            }
            else
            {
                self.updateUIValues()
            }
        }
    }
    
    func updateAllSliders(){
        setupSlider(slider: feedLowSlider, valueName: general.feed_low, value: Int(f11Values[general.feed_low] ?? "1" )!, min: 1, max: 10, interval: 1)
        setupSlider(slider: feedHighSlider, valueName: general.feed_high, value: Int(f11Values[general.feed_high] ?? "20" )!, min: 20, max: 80, interval: 1)
        setupSlider(slider: fanLowSlider, valueName: general.fan_low, value: Int(f11Values[general.fan_low] ?? "10" )!, min: 10, max: 50, interval: 1)
        setupSlider(slider: fanHighSlider, valueName: general.fan_high, value: Int(f11Values[general.fan_high] ?? "2" )!, min: 20, max: 50, interval: 1)
        setupSlider(slider: smokeFeedSlider, valueName: smoke.feed, value: Int(f11Values[smoke.feed] ?? "1" )!, min: 1, max: 15, interval: 1)
        setupSlider(slider: smokeFanSlider, valueName: smoke.fan, value: Int(f11Values[smoke.fan] ?? "5" )!, min: 5, max: 50, interval: 1)
        setupSlider(slider: smokePauseSlider, valueName: smoke.pause, value: Int(f11Values[smoke.pause] ?? "0" )!, min: 0, max: 50, interval: 1)
    }
    
   
    
    func setupSlider(slider: CustomSlider, valueName: String, value: Int, min: Int, max: Int, interval: Int){
        slider.delegate = self
        slider.sliderName = valueName
        slider.configureSlider(value: value, minValue: min, maxValue: max,  interval: interval)
        slider.setThumbColor(.red)
        slider.setThumbLabelColor(.red)
        slider.setTrackColor(.red)
    }
    
    
    
    
    func getFloatValue(value:String) -> Float {
        
        return (value as NSString).floatValue
    }
    
   
 
    
    
    @IBAction func lockUnlcok(_ sender: UIButton) {
        sender.setTitle("", for: .normal)
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
            
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                DispatchQueue.main.async {
                    loadingNotification.hide(animated: true)
                }
            }
            else
            {
                DispatchQueue.main.async {
                    loadingNotification.hide(animated: true)

                }
                self.concurrentQueue.async {
                    self.getF11Values()
                }

//                concurrentQueue.async {
//                }
//                if(key.contains("fan"))
//                {
//                    self.concurrentQueue.async(flags:.barrier) {
//                        self.getfanValue(callAuger: false)
//                    }
//                }else
//                {
//                    self.concurrentQueue.async(flags:.barrier) {
//                        self.getaugerValue()
//                    }
//                }
            }
        }
        
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
                         self.setvalue(key: "fan.speed_50", value:"55")
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
                         self.setvalue(key: "auger.auger_100", value:"35")
                     }
    }
    
    
    
    func showDialogBox(titleText: String, descriptionText: String){
        let dialogBox = DialogBox()
        dialogBox.configure(titleText: titleText, descriptionText: descriptionText, okBtnText: Language.getInstance().getlangauge(key: "ok"))
        
        dialogBox.modalPresentationStyle = .overCurrentContext
        dialogBox.modalTransitionStyle = .crossDissolve
        self.present(dialogBox, animated: true)
    }
    
    func showConfirmDialogBox(titleText: String, descriptionText: String, completionHandler: @escaping (()->Void)){
        let confirmDialogBox = ConfirmDialogBox()
        confirmDialogBox.configure(titleText: titleText, descriptionText: descriptionText, cancelText: Language.getInstance().getlangauge(key: "no"), confirmText: Language.getInstance().getlangauge(key: "yes")) {
            completionHandler()
        }
       
        confirmDialogBox.modalPresentationStyle = .overCurrentContext
        confirmDialogBox.modalTransitionStyle = .crossDissolve
        self.present(confirmDialogBox, animated: true)
    }
    
    
    // MARK: - Actions
    @IBAction func finish(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func feedLowBtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "general_feed_low_title")+" "+(f11Values[general.feed_low] ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "general_feed_low_description"))
    }
    
    @IBAction func feedHighBtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "general_feed_high_title")+" "+(f11Values[general.feed_high] ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "general_feed_high_description"))
    }
    
    @IBAction func fanLowBtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "general_fan_low_title")+" "+(f11Values[general.fan_low] ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "general_fan_low_description"))
    }
    
    @IBAction func fanHighBtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "general_fan_high_title")+" "+(f11Values[general.fan_high] ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "general_fan_high_description"))
    }
    
    @IBAction func smokeFeedBtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "smoke_feed_title")+" "+(f11Values[smoke.feed] ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "smoke_feed_description"))
    }
    
    @IBAction func smokeFanBtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "smoke_fan_title")+" "+(f11Values[smoke.fan] ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "smoke_fan_description"))
    }
    
    
    @IBAction func smokePauseBtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "smoke_pause_title")+" "+(f11Values[smoke.pause] ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "smoke_pause_description"))
    }
    
    @IBAction func infoBtnPressed(_ sender: Any) {
        guard let sVC = self.storyboard?.instantiateViewController(withIdentifier: "InfoViewController") as? InfoViewController else {
            return
        }
        sVC.modalPresentationStyle = .fullScreen
        self.present(sVC, animated: true, completion: nil)
    }
    
    
    @IBAction func resetBtnPressed(_ sender: Any) {
        showConfirmDialogBox(titleText: Language.getInstance().getlangauge(key: "reset_title"), descriptionText: Language.getInstance().getlangauge(key: "reset_description")) {
            self.setvalue(key: general.factory , value: "1" )
        }
    }
    
    @IBAction func advancedSettingsPressed(_ sender: Any) {
        guard let sVC = self.storyboard?.instantiateViewController(withIdentifier: "ServiceMenuViewController") as? ServiceMenuViewController else {
            return
        }
        sVC.modalPresentationStyle = .fullScreen
        self.present(sVC, animated: true, completion: nil)
    }
    
   

}

extension AdjustmentViewController: SliderDelegate {
    func getSliderValue(value: Float, sliderName: String) {
        print("changed", sliderName, value)
        concurrentQueue.async(flags:.barrier) {
            self.setvalue(key: sliderName, value: String(format: "%.0f", value))
        }
    }
}
