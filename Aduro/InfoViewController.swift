//
//  InfoViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 20/07/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit
import FGRoute
import MBProgressHUD

class InfoViewController: UIViewController {

    let concurrentQueue = DispatchQueue(label: "info Queue", attributes: .concurrent)

    @IBOutlet weak var serialLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var ovenDateLabel: UILabel!
    @IBOutlet weak var ovenTime: UILabel!
    @IBOutlet weak var ConnectionTypeLabel: UILabel!
    
    
    @IBOutlet weak var RotuerIPLabel: UILabel!
    @IBOutlet weak var SSIDLabel: UILabel!
    @IBOutlet weak var MacLabel: UILabel!
    @IBOutlet weak var OvenPowerLabel: UILabel!
    
    
    @IBOutlet weak var serialvalue: UILabel!
    @IBOutlet weak var passwordValue: UILabel!
    @IBOutlet weak var overdateValue: UILabel!
    @IBOutlet weak var ovenTimeValue: UILabel!
    @IBOutlet weak var connectionType: UILabel!
    @IBOutlet weak var routerIPValue: UILabel!
    @IBOutlet weak var SSIDValue: UILabel!
    @IBOutlet weak var MacValue: UILabel!
    @IBOutlet weak var ovenPowerValue: UILabel!
    
    @IBOutlet weak var cancelInternetSetting: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dateclicked))
        overdateValue.addGestureRecognizer(tap)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(timeclicked))
        ovenTimeValue.addGestureRecognizer(tap1)
        
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(clearSetting))
        cancelInternetSetting.addGestureRecognizer(tap2)
        
    labelset()

        // Do any additional setup after loading the view.
    }
    
    @objc func dateclicked()  {
        showDatePicker()
        
    }
    @objc func timeclicked()  {
        showTimePicker()
    }
    
    @objc func clearSetting(){
        
        concurrentQueue.async(flags:.barrier) {
            self.removeWifi()
        }
    }
    func removeWifi()  {
        
        var loadingNotification  : MBProgressHUD!
        DispatchQueue.main.async {
            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.indeterminate
                loadingNotification.label.text = "Loading"
                loadingNotification.detailsLabel.text = "Removing Wifi"
        }
      
          ControllerconnectionImpl.getInstance().reuqestSetWithoutEncrypt(key: "wifi.router", value: ",")
          { (ControllerResponseImpl) in
            DispatchQueue.main.async {
                loadingNotification.hide(animated: true)
            }
              if(ControllerResponseImpl.getPayload().contains("nothing"))
              {
                  print("error")
              }
              else
              {
              }
          }
      }
    func labelset() {
        serialLabel.text=Language.getInstance().getlangauge(key: "Serial")
        passwordLabel.text=Language.getInstance().getlangauge(key: "Password")
        ovenDateLabel.text=Language.getInstance().getlangauge(key: "controller_date")
        ovenTime.text=Language.getInstance().getlangauge(key: "controller_time")
        ConnectionTypeLabel.text=Language.getInstance().getlangauge(key: "info_connection_type")
        RotuerIPLabel.text=Language.getInstance().getlangauge(key: "info_router_ip")
        SSIDLabel.text=Language.getInstance().getlangauge(key: "info_ssid")
        MacLabel.text=Language.getInstance().getlangauge(key: "info_mac")
        OvenPowerLabel.text=Language.getInstance().getlangauge(key: "info_wifipower")
        cancelInternetSetting.text=Language.getInstance().getlangauge(key: "wizard_2_dont_wifi_button")
        
        getvalue()
    }
    @IBAction func finish(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func getvalue()  {
        concurrentQueue.async(flags:.barrier) {

            ControllerconnectionImpl.getInstance().requestRead(key: "wifi.router")
            { (ControllerResponseImpl) in
                
                if(ControllerResponseImpl.getPayload().contains("nothing"))
                {
//                    self.getvalue()
                }else
                {
                    DispatchQueue.main.async {
                        self.updateUI(map: ControllerResponseImpl.GetReadValue())
                    }
                }
            }
        }
    }
    func getf11()  {
        ControllerconnectionImpl.getInstance().requestF11Identified { (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
            }
            else
            {
                self.getvalue()
            }
        }
    }
    
    func updateUI(map:[String:String])  {
        let string = map["router"]
        if(map.count > 0)
        {
            var list = string?.split(separator: ",", maxSplits: Int.max, omittingEmptySubsequences: false)
            ovenPowerValue.text=String(list![6])
            serialvalue.text=ControllerconnectionImpl.getInstance().getController().getSerial()
            passwordValue.text=getpassword()
            connectionType.text=connectionTypefunction()
            routerIPValue.text=ControllerconnectionImpl.getInstance().getController().getIp()
            SSIDValue.text=FGRoute.getSSID()
            MacValue.text=String(list![9])
            ovenPowerValue.text=Language.getInstance().getlangauge(key: wifiSignalToString(value: String(list![6]))) + "(" + String(list![6]) + ")"
            
            
            
//            datetime
            var isoDate=ControllerconnectionImpl.getInstance().getFrontData()[IControllerConstants.time]
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "dd/mm-yy HH:mm:ss"
            let date = dateFormatter.date(from:isoDate!)!
            print(date)
            let formatDate = DateFormatter()
            formatDate.dateFormat = "dd/MM/yyyy"
            let drawDate = formatDate.string(from: date)
            overdateValue.text=drawDate
            let formatDate1 = DateFormatter()
            formatDate1.dateFormat = "HH:mm"
            let drawDate1 = formatDate1.string(from: date)
            ovenTimeValue.text=drawDate1
            
            if(isCloud(value: String(list![1])))
            {
                ovenDateLabel.text=Language.getInstance().getlangauge(key: "controller_date") + "( " + Language.getInstance().getlangauge(key: "clock_synchronized") + " )"
                ovenTime.text=Language.getInstance().getlangauge(key: "controller_time") + "( " + Language.getInstance().getlangauge(key: "clock_synchronized") + " )"
                
                overdateValue.isUserInteractionEnabled=false
                ovenTimeValue.isUserInteractionEnabled=false
//                showDatePicker()
            }else
            {
                ovenDateLabel.text=Language.getInstance().getlangauge(key: "controller_date")
                ovenTime.text=Language.getInstance().getlangauge(key: "controller_time")
                
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "arrow_down_float")
                let attachmentString = NSAttributedString(attachment: attachment)
                let myString = NSMutableAttributedString(string: drawDate)
                myString.append(attachmentString)
                overdateValue.attributedText = myString
                let myString1 = NSMutableAttributedString(string: drawDate1)
                myString1.append(attachmentString)
                ovenTimeValue.attributedText = myString1
                
                
                overdateValue.isUserInteractionEnabled=true
                ovenTimeValue.isUserInteractionEnabled=true
//                showDatePicker()
                

            }
        }
      
        
    }
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    func showDatePicker(){
        
        datePicker = UIDatePicker.init()
        datePicker.backgroundColor = UIColor.darkGray
        
        datePicker.autoresizingMask = .flexibleWidth
        datePicker.datePickerMode = .date
        
        datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(datePicker)
        
        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .blackTranslucent
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil),UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancel)), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
        toolBar.sizeToFit()
        self.view.addSubview(toolBar)
    }
    var timePicker  = UIDatePicker()
    func showTimePicker(){
        
        
        timePicker = UIDatePicker.init()
        timePicker.datePickerMode = .time
        timePicker.backgroundColor = UIColor.darkGray
        
        timePicker.autoresizingMask = .flexibleWidth
        timePicker.datePickerMode = .time
        timePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        
        timePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(timePicker)
        
        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .blackTranslucent
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil),UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancel)), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.ondonetimeClicked))]
        toolBar.sizeToFit()
        self.view.addSubview(toolBar)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        print(sender)
        var components = Calendar.current.dateComponents([.year,.month,.day,.minute, .hour], from: sender!.date)
        print(components.year)
//        txtDatePicker.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
//        self.view.endEditing(true)
    }
    @objc func onDoneButtonClick(){
        //cancel button dismiss datepicker dialog
//        self.view.endEditing(true)
        
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
        timePicker.removeFromSuperview()
        var components = Calendar.current.dateComponents([.year,.month,.day,.minute, .hour], from: datePicker.date)
        var timecomponents1 = Calendar.current.dateComponents([.year,.month,.day,.minute, .hour], from: timePicker.date)

        var Month:String
        if(String(components.month!).count == 1)
        {
            Month="0" + String(components.month!)
        }else
        {
            Month=String(components.month!)
        }
        concurrentQueue.async(flags:.barrier) {
            self.updateDateTime(payload: "misc.clock_year", value: String(components.year! - 2000))
        }
        concurrentQueue.async(flags:.barrier) {
            self.updateDateTime(payload: "misc.clock_month", value: Month)
        }
        concurrentQueue.async(flags:.barrier) {
            self.updateDateTime(payload: "misc.clock_date", value: String(components.day!))
        }
        concurrentQueue.async(flags:.barrier) {
            self.updateDateTime(payload: "misc.clock_hour", value: String(timecomponents1.hour!))
        }
        concurrentQueue.async(flags:.barrier) {
            self.updateDateTime(payload: "misc.clock_minute", value: String(timecomponents1.minute!))
        }
        concurrentQueue.async(flags:.barrier) {
            self.updateDateTime(payload: "misc.clock_second", value: "00")
        }
        concurrentQueue.async(flags:.barrier) {
            self.updateDateTime(payload: "misc.clock_changed", value: "1")
        }
        concurrentQueue.async(flags:.barrier) {
            self.getf11()
        }
    }
    
    @objc func ondonetimeClicked()
    {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
        timePicker.removeFromSuperview()
        var datecomponents = Calendar.current.dateComponents([.year,.month,.day,.minute, .hour], from: datePicker.date)
        var timecomponents1 = Calendar.current.dateComponents([.year,.month,.day,.minute, .hour], from: timePicker.date)
        var Month:String
        if(String(datecomponents.month!).count == 1)
        {
            Month="0" + String(datecomponents.month!)
        }else
        {
            Month=String(datecomponents.month!)
        }
        concurrentQueue.async(flags:.barrier) {
            self.updateDateTime(payload: "misc.clock_year", value: String(datecomponents.year! - 2000))
        }
        concurrentQueue.async(flags:.barrier) {
            self.updateDateTime(payload: "misc.clock_month", value: Month)
        }
        concurrentQueue.async(flags:.barrier) {
            self.updateDateTime(payload: "misc.clock_date", value: String(datecomponents.day!))
        }
        concurrentQueue.async(flags:.barrier) {
            self.updateDateTime(payload: "misc.clock_hour", value: String(timecomponents1.hour!))
        }
        concurrentQueue.async(flags:.barrier) {
            self.updateDateTime(payload: "misc.clock_minute", value: String(timecomponents1.minute!))
        }
        concurrentQueue.async(flags:.barrier) {
            self.updateDateTime(payload: "misc.clock_second", value: "00")
        }
        concurrentQueue.async(flags:.barrier) {
            self.updateDateTime(payload: "misc.clock_changed", value: "1")
        }
        concurrentQueue.async(flags:.barrier) {
            self.getf11()
        }
        
  }
    @objc func cancel()  {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
        timePicker.removeFromSuperview()
    }
    
    func updateDateTime(payload:String,value:String)  {
    
        ControllerconnectionImpl.getInstance().requestSet(key: payload, value: value, encryptionMode: "-") { (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                
            }
            else
            {
                
            }
            
        }
    }
  
    
    
    func isCloud(value:String) -> Bool {
        return value=="2"
    }
    func wifiSignalToString(value:String) -> String {
        let d = Double(value)
        let int = Int(d!)
        
        if(int >= -48)
        {
            return  "wifi-0";
        }
        else if(int >= -58)
        {
            return "wifi-1";
        }
        else if(int >= -65)
        {
            return "wifi-2";
        }
        else if(int >= -72)
        {
            return "wifi-3";
        }
        else if(int >= -150)
        {
            return "wifi-4";
        }
        else
        {
            return "wifi-5";
        }
    }
    func getpassword() -> String {
        var pwd=""
        let current=ControllerconnectionImpl.getInstance().getController().getPassword()
        for (index,value) in current.enumerated()
        {
            if(index<8)
            {
                pwd = pwd + "*"
            }else
            {
                pwd = pwd + String(value)
            }
        }
        
        return pwd
    
    }
    
    func connectionTypefunction() -> String {
        var ip=ControllerconnectionImpl.getInstance().getController().getIp()
        if(ip=="apprelay20.stokercloud.dk")
        {
            return Language.getInstance().getlangauge(key: "cloud")
        }else if (ip=="192.168.4.1")
        {
            return Language.getInstance().getlangauge(key: "direct")
        }else
        {
            return Language.getInstance().getlangauge(key: "wifi")
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
