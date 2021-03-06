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
    
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var advancedSettingsBtn: UIButton!
    @IBOutlet weak var resetSettingsBtn: UIButton!
    @IBOutlet weak var feedLowBtn: UIButton!
    @IBOutlet weak var feedHighBtn: UIButton!
    @IBOutlet weak var fanLowBtn: UIButton!
    @IBOutlet weak var fanHighBtn: UIButton!
    @IBOutlet weak var smokeFeedBtn: UIButton!
    @IBOutlet weak var smokeFanBtn: UIButton!
    @IBOutlet weak var smokePauseBtn: UIButton!
    
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
    
        infoBtn.setAttributedTitle(NSAttributedString(string: Language.getInstance().getlangauge(key:"info_title")), for: .normal)
        resetSettingsBtn.setAttributedTitle(NSAttributedString(string:Language.getInstance().getlangauge(key:"Reset_settings")), for: .normal)
        advancedSettingsBtn.setAttributedTitle(NSAttributedString(string:Language.getInstance().getlangauge(key:"advance_setting")), for: .normal)
        
        
        //        self.gradient.installGradientwithvounds(frame: self.view.bounds)
        //
        //        self.gradient.updateGradient(frame: self.view.bounds)
        
//        disable()

        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {

    }
    
    func updateUIValues(){
        self.f11Values = ControllerconnectionImpl.getInstance().getFrontData()
        print("f11Values", self.f11Values)
        self.updateAllSliders()
        self.setCurrentValues()
    }
    
    func setCurrentValues(){
        feedLowBtn.setAttributedTitle(NSAttributedString(string: f11Values[general.feed_low] ?? "-"), for: .normal)
        feedHighBtn.setAttributedTitle(NSAttributedString(string: f11Values[general.feed_high] ?? "-"), for: .normal)
        fanLowBtn.setAttributedTitle(NSAttributedString(string: f11Values[general.fan_low] ?? "-"), for: .normal)
        fanHighBtn.setAttributedTitle(NSAttributedString(string: f11Values[general.fan_high] ?? "-"), for: .normal)
        smokeFeedBtn.setAttributedTitle(NSAttributedString(string: f11Values[smoke.feed] ?? "-"), for: .normal)
        smokeFanBtn.setAttributedTitle(NSAttributedString(string: f11Values[smoke.fan] ?? "-"), for: .normal)
        smokePauseBtn.setAttributedTitle(NSAttributedString(string: f11Values[smoke.pause] ?? "-"), for: .normal)
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
        setupSlider(slider: fanHighSlider, valueName: general.fan_high, value: Int(f11Values[general.fan_high] ?? "2" )!, min: 20, max: 100, interval: 1)
        setupSlider(slider: smokeFeedSlider, valueName: smoke.feed, value: Int(f11Values[smoke.feed] ?? "1" )!, min: 1, max: 15, interval: 1)
        setupSlider(slider: smokeFanSlider, valueName: smoke.fan, value: Int(f11Values[smoke.fan] ?? "5" )!, min: 5, max: 50, interval: 1)
        setupSlider(slider: smokePauseSlider, valueName: smoke.pause, value: Int(f11Values[smoke.pause] ?? "0" )!, min: 0, max: 50, interval: 1)
    }
    
   
    
    func setupSlider(slider: CustomSlider, valueName: String, value: Int, min: Int, max: Int, interval: Int){
        slider.delegate = self
        slider.sliderName = valueName
        slider.configureSlider(value: value, minValue: min, maxValue: max,  interval: interval)
        slider.setThumbColor(.red)
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
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "Pellet_Feed_Min_Power_header")+" "+(f11Values[general.feed_low] ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "Pellet_Feed_Min_Power_text"))
    }
    
    @IBAction func feedHighBtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "Pellet_Feed_Max_Power_header")+" "+(f11Values[general.feed_high] ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "Pellet_Feed_Max_Power_text"))
    }
    
    @IBAction func fanLowBtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "Fan_Speed_Min_Power_header")+" "+(f11Values[general.fan_low] ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "Fan_Speed_Min_Power_text"))
    }
    
    @IBAction func fanHighBtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "Fan_Speed_Max_Power_header")+" "+(f11Values[general.fan_high] ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "Fan_Speed_Max_Power_text"))
    }
    
    @IBAction func smokeFeedBtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "Pellet_Feed_Smoking_header")+" "+(f11Values[smoke.feed] ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "Pellet_Feed_Smoking_text"))
    }
    
    @IBAction func smokeFanBtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "Fan_Speed_Smoking_header")+" "+(f11Values[smoke.fan] ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "Fan_Speed_Smoking_text"))
    }
    
    
    @IBAction func smokePauseBtnPressed(_ sender: Any) {
        showDialogBox(titleText: Language.getInstance().getlangauge(key: "Fan_Sleep_Smoking_header")+" "+(f11Values[smoke.pause] ?? "-"), descriptionText: Language.getInstance().getlangauge(key: "Fan_Sleep_Smoking_text"))
    }
    
    @IBAction func infoBtnPressed(_ sender: Any) {
        guard let sVC = self.storyboard?.instantiateViewController(withIdentifier: "InfoViewController") as? InfoViewController else {
            return
        }
        sVC.modalPresentationStyle = .fullScreen
        self.present(sVC, animated: true, completion: nil)
    }
    
    
    @IBAction func resetBtnPressed(_ sender: Any) {
        showConfirmDialogBox(titleText: Language.getInstance().getlangauge(key: "reset_header"), descriptionText: Language.getInstance().getlangauge(key: "reset_text")) {
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
