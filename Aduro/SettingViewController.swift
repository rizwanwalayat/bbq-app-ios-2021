//
//  SettingViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 16/07/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    let concurrentQueue = DispatchQueue(label: "setting Queue", attributes: .concurrent)

    @IBOutlet weak var heatlevel: UILabel!
    @IBOutlet weak var Wanted_room: UILabel!
    @IBOutlet weak var time_table: UILabel!
    
    
    @IBOutlet weak var firstLayout: MyCustomView!
    @IBOutlet weak var secondLayout: MyCustomView!
    @IBOutlet weak var thirdLayout: MyCustomView!
    
    
    @IBOutlet weak var fireSmall: UIImageView!
    @IBOutlet weak var medium: UIImageView!
    @IBOutlet weak var large: UIImageView!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var slidertext: UILabel!
    
    @IBOutlet weak var timeTableLabel: UIButton!
    
    
    
    @IBOutlet weak var stopStart: UIView!
    @IBOutlet weak var AdjustmentOpen: UIView!
    @IBOutlet weak var timetableOpen: UIView!
    @IBOutlet weak var wizardopen: UIView!
    @IBOutlet weak var infoOpen: UIView!
    @IBOutlet weak var selectLanguage: UIView!
    
    
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var statusText: UILabel!
    
    
    @IBOutlet weak var ovn_image: UIImageView!
    
    @IBOutlet weak var languageImage: UIImageView!
    let defaults = UserDefaults.standard

    
    @IBOutlet weak var timetableLabel: UILabel!
    @IBOutlet weak var adjusmentLabel: UILabel!
    @IBOutlet weak var wizardLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    
    
    var operationMode=""
    var NewoperationMode="";
    var timetableEnabled=""
    var NewtimetableEnabled="";
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settext()
        updatefromF11()
        checkoperationMode()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        if(operationMode != "")
        {
            if(operationMode != NewoperationMode)
            {

                concurrentQueue.async(flags:.barrier) {
                    self.setvalue(value: self.NewoperationMode, key: "regulation.operation_mode")
                }
            }
        }
        if(timetableEnabled != "")
        {
            if(timetableEnabled != NewtimetableEnabled)
            {
                
                concurrentQueue.async(flags:.barrier) {
                    self.setvalue(value: self.NewtimetableEnabled, key: "boiler.timer")
                }
            }
        }
    }
    
    func settext() {
        
        
        timetableLabel.text=Language.getInstance().getlangauge(key: "timetable_header")
        adjusmentLabel.text=Language.getInstance().getlangauge(key: "adjust_text")
        wizardLabel.text=Language.getInstance().getlangauge(key: "Wizard")
        infoLabel.text=Language.getInstance().getlangauge(key: "info_title")
        languageLabel.text=Language.getInstance().getlangauge(key: "lng_selectLng")
        
        heatlevel.text = Language.getInstance().getlangauge(key: "level")
        Wanted_room.text = Language.getInstance().getlangauge(key: "setting_prefTmp")
        time_table.text = Language.getInstance().getlangauge(key: "setting_prefTimeTable")
        
        let tapgestureFirst = UITapGestureRecognizer(target: self, action: #selector(self.FirstlayoutTap))
        firstLayout.addGestureRecognizer(tapgestureFirst)
        let tapgestureSecond = UITapGestureRecognizer(target: self, action: #selector(self.SecondlayoutTap))
        secondLayout.addGestureRecognizer(tapgestureSecond)
        let tapgestureThird = UITapGestureRecognizer(target: self, action: #selector(self.ThirdlayoutTap))
        thirdLayout.addGestureRecognizer(tapgestureThird)
        
        
        let smalltap = UITapGestureRecognizer(target: self, action: #selector(self.firetap(_:)))
        fireSmall.addGestureRecognizer(smalltap)
        let mediumtap = UITapGestureRecognizer(target: self, action: #selector(self.firetap(_:)))
        medium.addGestureRecognizer(mediumtap)
        let largertap = UITapGestureRecognizer(target: self, action: #selector(self.firetap(_:)))
        large.addGestureRecognizer(largertap)
        
        
        
        let timtabletap = UITapGestureRecognizer(target: self, action: #selector(self.timetap(_:)))
        timeTableLabel.addGestureRecognizer(timtabletap)
        
        
        let stopStarttap = UITapGestureRecognizer(target: self, action: #selector(self.stopstartfunc))
        stopStart.addGestureRecognizer(stopStarttap)
        let AdjustmentOpentap = UITapGestureRecognizer(target: self, action: #selector(self.Adjustmentfunc))
        AdjustmentOpen.addGestureRecognizer(AdjustmentOpentap)
        let timetableOpentap = UITapGestureRecognizer(target: self, action: #selector(self.timetablefunc))
        timetableOpen.addGestureRecognizer(timetableOpentap)
        let wizardopentap = UITapGestureRecognizer(target: self, action: #selector(self.wizardfunc))
        wizardopen.addGestureRecognizer(wizardopentap)
        let infoOpentap = UITapGestureRecognizer(target: self, action: #selector(self.infofunc))
        infoOpen.addGestureRecognizer(infoOpentap)
        let selectLanguagetap = UITapGestureRecognizer(target: self, action: #selector(self.seleclangfunc))
        selectLanguage.addGestureRecognizer(selectLanguagetap)

        let language=defaults.string(forKey: Constants.languageKey)
        languageImage.image=UIImage(named: language!)
//        firstLayout.alpha=0.4
//        secondLayout.isUserInteractionEnabled=false
        FirstlayoutTap()
    }
    
   @objc func stopstartfunc() {
    var map=ControllerconnectionImpl.getInstance().getFrontData()
    if(map.count>0)
    {
     
        if(map[IControllerConstants.state] == "23")
        {
            concurrentQueue.async(flags:.barrier){

                self.setvalue(value: "1", key: "misc.stop")
            }
            
            statusImage.image=UIImage(named: "onoff_pressed2.png")
        }else if(map[IControllerConstants.state] != "23")
        {
            switch map[IControllerConstants.offOnAlarm] {
            case "0":
                concurrentQueue.async(flags:.barrier){

                    self.setvalue(value: "1", key: "misc.start")
                }
                break
            case "1":
                concurrentQueue.async(flags:.barrier){

                    self.setvalue(value: "1", key: "misc.stop")
                }
                break
            case "2":
                concurrentQueue.async(flags:.barrier){

                    self.setvalue(value: "1", key: "misc.reset_alarm")
                }
                break
            default:
                break
            }
        }
    }
    }
    
    @objc func Adjustmentfunc() {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "AdjustmentViewController") as? AdjustmentViewController else { return}
        sVC.modalPresentationStyle = .fullScreen
        self.present(sVC, animated: true)
        
    }
    @objc func timetablefunc() {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "TimeTableViewController") as? TimeTableViewController else { return}
        sVC.modalPresentationStyle = .fullScreen
        self.present(sVC, animated: true)
        
    }
    @objc func wizardfunc() {
                 guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "WizardMainViewController") as? WizardMainViewController else { return}
        
        sVC.modalPresentationStyle = .fullScreen
                self.present(sVC, animated: true)
//                dismiss(animated: true)
    }
    @objc func infofunc() {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "InfoViewController") as? InfoViewController else { return}
        sVC.modalPresentationStyle = .fullScreen
        self.present(sVC, animated: true)
    }
    @objc func seleclangfunc() {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "LanguageViewController") as? LanguageViewController else { return}
        sVC.fromsetting=true
        sVC.modalPresentationStyle = .fullScreen
        self.present(sVC, animated: true)
    }

    
   @objc func timetap(_ sender:UITapGestureRecognizer)
    {
        if(thirdLayout.alpha < 0.5)
        {
            ThirdlayoutTap()
        }
        else if(sender.view==timeTableLabel)
        {
            print("time table press")
        }
    }
    
    @objc func firetap(_ sender:UITapGestureRecognizer)  {
        if(firstLayout.alpha < 0.5)
        {
         FirstlayoutTap()
        }

        NewoperationMode="0";
        NewtimetableEnabled="0";
         if(sender.view==fireSmall)
        {
            print("small")
            concurrentQueue.async(flags:.barrier) {

                self.setvalue(value: "10", key: IControllerConstants.regulationFixedPower)
            }
        }else if(sender.view==medium)
        {
            print("medium")
            concurrentQueue.async(flags:.barrier) {
                self.setvalue(value: "50", key: IControllerConstants.regulationFixedPower)
            }

        }else if(sender.view==large)
        {
            print("large")
            concurrentQueue.async(flags:.barrier) {
                self.setvalue(value: "100", key: IControllerConstants.regulationFixedPower)
            }

        }

    }
    
    @objc func FirstlayoutTap()  {

        NewoperationMode="0";
        NewtimetableEnabled="0";
        print("first tap")
        firstLayout.alpha=1
        secondLayout.alpha=0.4
        thirdLayout.alpha=0.4
        
        slider.isUserInteractionEnabled=false
        var object = ControllerconnectionImpl.getInstance().getFrontData()
        if(object.count>0)
        {
            var heat = heatLevel(string: object[IControllerConstants.regulationFixedPower]!)
                  if(heat==1)
                  {
                      fireSmall.alpha=1
                      medium.alpha=0.4
                      large.alpha=0.4
                  }else if(heat==2)
                  {
                      
                      fireSmall.alpha=0.4
                      medium.alpha=1
                      large.alpha=0.4
                  }else if(heat==3)
                  {
                      
                      fireSmall.alpha=0.4
                      medium.alpha=0.4
                      large.alpha=1
                  }else
                  {
                      
                      fireSmall.alpha=0.4
                      medium.alpha=0.4
                      large.alpha=0.4
                  }
        }
      
        
    }
    @objc func SecondlayoutTap()  {

        NewoperationMode="1";
        NewtimetableEnabled="0";
        firstLayout.alpha=0.4
        secondLayout.alpha=1
        thirdLayout.alpha=0.4
        
        
        slider.isUserInteractionEnabled=true
        
    }
    @objc func ThirdlayoutTap()  {
        NewtimetableEnabled = "1";
        print("third layout")
        firstLayout.alpha=0.4
        secondLayout.alpha=0.4
        thirdLayout.alpha=1
        
        
        slider.isUserInteractionEnabled=false
    }
    
    
    func heatLevel(string:String) -> Int {
        
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
    func updatefromF11()  {
        if(ControllerconnectionImpl.getInstance().getFrontData().count != 0)
        {
//            let
            let map=ControllerconnectionImpl.getInstance().getFrontData()
            setimage()
            let string=Language.getInstance().getlangauge(key: "setting_prefTmp")
            let finalstring=string.replacingOccurrences(of: "{{current}}", with: map[IControllerConstants.boilerRef]!)
            Wanted_room.text = finalstring + "°C"
            slidertext.text = map[IControllerConstants.boilerRef]
            let f:Float = (map[IControllerConstants.boilerRef]! as NSString).floatValue
            slider.setValue(f, animated: true)
            
            if(map[IControllerConstants.state] == "23")
            {
                statusImage.image=UIImage(named: "onoff2")
                statusText.text=Language.getInstance().getlangauge(key: "setting_off")
            }else if(map[IControllerConstants.state] != "23")
            {
                checkStateforOnOFF(state: map[IControllerConstants.state]!, on_off_alar: map[IControllerConstants.offOnAlarm]!)
            }

        }
    }
    
    func checkoperationMode()  {
        if(ControllerconnectionImpl.getInstance().getFrontData().count != 0)
        {
            operationMode=ControllerconnectionImpl.getInstance().getFrontData()[IControllerConstants.operationMode]!
            timetableEnabled=ControllerconnectionImpl.getInstance().getFrontData()[IControllerConstants.boilerTime]!
            NewoperationMode=ControllerconnectionImpl.getInstance().getFrontData()[IControllerConstants.operationMode]!
            NewtimetableEnabled=ControllerconnectionImpl.getInstance().getFrontData()[IControllerConstants.boilerTime]!
            
            if(timetableEnabled == "1")
            {
                ThirdlayoutTap()
            }else if (operationMode == "1")
            {
                SecondlayoutTap()
            }else
            {
                FirstlayoutTap()
            }
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
    func checkStateforOnOFF(state:String,on_off_alar:String)   {
        
        var operation_status:String;
        if(state=="28")
        {
            operation_status="8";
        }else if(state=="0")
        {
            operation_status="4";
        }else
        {
            operation_status=on_off_alar;
        }
        setonoffbutton(operation_status: operation_status)
    }
    func setonoffbutton(operation_status:String)
    {
        switch operation_status {
        case "0":
            statusImage.image=UIImage(named: "onoff_green2")
            statusText.text=Language.getInstance().getlangauge(key: "setting_on")
            break
        case "1":
            statusImage.image=UIImage(named: "onoff2")
            statusText.text=Language.getInstance().getlangauge(key: "setting_off")
            break
        case "2":
            statusImage.image=UIImage(named: "onoff_red2")
            statusText.text=Language.getInstance().getlangauge(key: "setting_alarmStop")
            break
        default:
            statusImage.image=UIImage(named: "onoff2")
            statusText.text=Language.getInstance().getlangauge(key: "setting_on")
            break
        }
    }
    @IBAction func finish(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func sliderEnd(_ sender: Any) {
        print("slider end" + String((sender as! UISlider).value))
        let d=Double(String((sender as! UISlider).value))
        self.concurrentQueue.async(flags:.barrier) {
            self.setvalue(value: String(format: "%.2f", d!), key: "boiler.temp")
        }
    }
    
    @IBAction func sliderContinue(_ sender: UISlider) {
         let d=Double(String(sender.value))
        slidertext.text = String(format: "%.2f", d!) + "°C"
    }
    
    func setvalue(value:String,key:String) {
        ControllerconnectionImpl.getInstance().requestSet(key: key, value: value, encryptionMode: "-")
        { (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                
                print("set not from setting")
            }else
            {
                print("set ok")
                self.concurrentQueue.async(flags:.barrier) {
                    self.getf11(payload: key)
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

    
    
    func getf11(payload:String)  {
        ControllerconnectionImpl.getInstance().requestF11Identified
            {
                (ControllerResponseImpl) in
                if(ControllerResponseImpl.getPayload().contains("nothing"))
                {
                    print("error")
                    
                }
                else
                {
                   if(payload==IControllerConstants.regulationFixedPower)
                   {
                    self.FirstlayoutTap()
                    }
                    self.updatefromF11()
                }
                
        }
    }
}
