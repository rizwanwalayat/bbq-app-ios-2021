//
//  ManualViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 17/08/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit

class ManualViewController: UIViewController {

    let concurrentQueue = DispatchQueue(label: "manual Queue", attributes: .concurrent)

    
    @IBOutlet weak var tap1: UIView!
    @IBOutlet weak var tap2: UIView!
    @IBOutlet weak var tap3: UIView!
    @IBOutlet weak var tap4: UIView!
    @IBOutlet weak var tap5: UIView!
    @IBOutlet weak var tap6: UIView!
    @IBOutlet weak var tap7: UIView!
    
    
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var title3: UILabel!
    @IBOutlet weak var title4: UILabel!
    @IBOutlet weak var title5: UILabel!
    @IBOutlet weak var title6: UILabel!
    @IBOutlet weak var title7: UILabel!
    
    
    @IBOutlet weak var manualTime1: UILabel!
    @IBOutlet weak var manualTime2: UILabel!
    @IBOutlet weak var manualTime3: UILabel!
    @IBOutlet weak var manualTime4: UILabel!
    @IBOutlet weak var manualTime5: UILabel!
    @IBOutlet weak var manualTime6: UILabel!
    @IBOutlet weak var manualTime7: UILabel!
    
    
    @IBOutlet weak var manualCross1: UIButton!
    @IBOutlet weak var manualCross2: UIButton!
    @IBOutlet weak var manualCross3: UIButton!
    @IBOutlet weak var manualCross4: UIButton!
    @IBOutlet weak var manualCross5: UIButton!
    @IBOutlet weak var manualCross6: UIButton!
    @IBOutlet weak var manualCross7: UIButton!
    
    var  countDownTimermode1,countDownTimermode2,countDownTimermode3,countDownTimermode4,countDownTimermode5,countDownTimermode6,countDownTimermode7,timer1,timer : Timer!
    
    var time = 600,timer2 = 600,timer3 = 600,timer4 = 600,timer5 = 600,timer6 = 600,timer7 = 600
    var manualTerminalCount: Int=7;
    var manualOffTrans: String="off";
    
    var manualInfo:[String:String]=[:]
    override func viewDidLoad() {
        super.viewDidLoad()
        settext()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func finish(_ sender: UIButton) {

        if(ControllerconnectionImpl.getInstance().getController().getSerial() == "12345")
        {
            self.dismiss(animated: true) {
                                     self.stopAllTimer()
                                 }
        }else
        {
            self.concurrentQueue.async(flags:.barrier) {
                          self.manualModeOn_Off_Switch(switch1: false)
                      }
        }
    }
    
    
    func settext()  {
        
        
        let tapgesture1 = UITapGestureRecognizer(target: self, action: #selector(self.versiontap1))
        tap1.addGestureRecognizer(tapgesture1)
        let tapgesture2 = UITapGestureRecognizer(target: self, action: #selector(self.versiontap2))
        tap2.addGestureRecognizer(tapgesture2)
        let tapgesture3 = UITapGestureRecognizer(target: self, action: #selector(self.versiontap3))
        tap3.addGestureRecognizer(tapgesture3)
        let tapgesture4 = UITapGestureRecognizer(target: self, action: #selector(self.versiontap4))
        tap4.addGestureRecognizer(tapgesture4)
        let tapgesture5 = UITapGestureRecognizer(target: self, action: #selector(self.versiontap5))
        tap5.addGestureRecognizer(tapgesture5)
        let tapgesture6 = UITapGestureRecognizer(target: self, action: #selector(self.versiontap6))
        tap6.addGestureRecognizer(tapgesture6)
        let tapgesture7 = UITapGestureRecognizer(target: self, action: #selector(self.versiontap7))
        tap7.addGestureRecognizer(tapgesture7)
        
        title1.text=Language.getInstance().getlangauge(key: "manual_terminal_1")
        title2.text=Language.getInstance().getlangauge(key: "manual_terminal_2")
        title3.text=Language.getInstance().getlangauge(key: "manual_terminal_3")
        title4.text=Language.getInstance().getlangauge(key: "manual_terminal_4")
        title5.text=Language.getInstance().getlangauge(key: "manual_terminal_5")
        title6.text=Language.getInstance().getlangauge(key: "manual_terminal_6")
        title7.text=Language.getInstance().getlangauge(key: "manual_terminal_7")
        
        
        manualTime1.text=Language.getInstance().getlangauge(key: "off")
        manualTime2.text=Language.getInstance().getlangauge(key: "off")
        manualTime3.text=Language.getInstance().getlangauge(key: "off")
        manualTime4.text=Language.getInstance().getlangauge(key: "off")
        manualTime5.text=Language.getInstance().getlangauge(key: "off")
        manualTime6.text=Language.getInstance().getlangauge(key: "off")
        manualTime7.text=Language.getInstance().getlangauge(key: "off")
        
        for inex in 1...manualTerminalCount
          {
            manualInfo["l" + String(inex)] = manualOffTrans
            manualInfo["l" + String(inex) + "_second"] = "-1"
        }
        startManual()
    }
    
    
    @objc func versiontap1()
    {
        manualMode(mode: 1)
    }
    @objc func versiontap2()
    {
        manualMode(mode: 2)
    }
    @objc func versiontap3()
    {
        manualMode(mode: 3)
    }
    @objc func versiontap4()
    {
        manualMode(mode: 4)
    }
    @objc func versiontap5()
    {
        manualMode(mode: 5)
    }
    @objc func versiontap6()
    {
        manualMode(mode: 6)
    }
    @objc func versiontap7()
    {
        manualMode(mode: 7)
    }
    
     
    func startManual()  {
        
         timer = Timer.scheduledTimer(withTimeInterval: 600, repeats: false)
        { (Timer) in
            
            self.concurrentQueue.async(flags:.barrier) {
                self.manualModeOn_Off_Switch(switch1: false)
            }
        }
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        
        self.concurrentQueue.async(flags:.barrier) {
                      self.manualModeOn_Off_Switch(switch1: true)
                  }
        
        timer1 = Timer.scheduledTimer(withTimeInterval: 5, repeats: true)
        { (Timer) in
            
            self.concurrentQueue.async(flags:.barrier) {
                self.keep_alive()
            }
        }
        RunLoop.current.add(timer1, forMode: RunLoop.Mode.common)
        

    }
    
    func keep_alive()
    {
        ControllerconnectionImpl.getInstance().requestSet(key: "manual.keep_alive", value: "1", encryptionMode: "-")
        { (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                
            }
            else
            {
               print("keep alive send")
            }
        }
    }
    
    func manualModeOn_Off_Switch(switch1:Bool)
    {
        var valuetosend="1"
        if(switch1)
        {
            valuetosend="1"
        }else
        {
            valuetosend="0"
        }
        ControllerconnectionImpl.getInstance().requestSet(key: "manual.manual_mode", value: valuetosend, encryptionMode: "-")
        { (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                
            }
            else
            {
                if(switch1==false)
                {
//                    self.dismiss(animated: true)
                    DispatchQueue.main.async {
                        self.dismiss(animated: true) {
                            self.stopAllTimer()
                        }
                    }
                    print("stop")
                }else
                {
                    print("start")
                }
            }
        }
    }
    
    func stopAllTimer() {
        if(countDownTimermode1 != nil)
        {
            countDownTimermode1.invalidate()
        }
        if(countDownTimermode2 != nil)
        {
            countDownTimermode2.invalidate()
        }
        if(countDownTimermode3 != nil)
        {
            countDownTimermode3.invalidate()
        }
        if(countDownTimermode4 != nil)
        {
            countDownTimermode4.invalidate()
        }
        if(countDownTimermode5 != nil)
        {
            countDownTimermode5.invalidate()
        }
        if(countDownTimermode6 != nil)
        {
            countDownTimermode6.invalidate()
        }
        if(countDownTimermode7 != nil)
        {
            countDownTimermode7.invalidate()
        }
        if(timer1 != nil)
        {
            timer1.invalidate()
        }
        if(timer != nil)
        {
            timer.invalidate()
        }
        
    }
    func manualMode(mode:Int)  {
//        if(mode==1)
//        {
//            if(manualInfo["l1"] != "Off"){}
//            if(manualInfo["l1"] != "off" && manualInfo["l3"] != "off")
//            {
//                manualMode(mode: 3);
//            }else if(manualInfo["l1"] == "off" && manualInfo["l3"] == "off")
//            {
//                manualMode(mode: 3);
//            }
//        }
        
        var currentMode = manualInfo["l"+String(mode)]
        
        if(currentMode == manualOffTrans)
        {
            manualInfo["l" + String(mode)]="'00:00'"
            manualInfo["l" + String(mode) + "_second"]="0"
            self.setCountDownTimer(mode: mode, stop: false)
        }else
        {
            manualInfo["l" + String(mode)]=manualOffTrans
            self.setCountDownTimer(mode: mode, stop: true)
        }
        
        var bit = 1; // 2, 4, 8, 16
        var val = 0; // 4
        
        
        for index in 1...manualTerminalCount
        {
            if(manualInfo["l"+String(index)] != manualOffTrans)
            {
                val = val | bit
            }
            
            bit = bit << 1
        }
        self.concurrentQueue.async(flags:.barrier) {
            self.output_std(value: String(val))
        }
    }
    
    
    
    func setCountDownTimer(mode:Int,stop:Bool)
    {
        
        if(mode==1)
        {
            if(stop)
            {
                if(countDownTimermode1.isValid)
                {
                    DispatchQueue.main.async {
                        self.countDownTimermode1.invalidate()
                        self.manualCross1.setTitle("", for: .normal)
                        self.manualCross1.setTitleColor(UIColor(named: "red"), for: .normal)
                        self.manualTime1.text = Language.getInstance().getlangauge(key: "off")
                    }
                }
            }else
            {
               countDownTimermode1 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)
                { (Timer) in
//                    print("counter 1 chal raha")
                    DispatchQueue.main.async {

                        self.manualCross1.setTitle("", for: .normal)
                        self.manualCross1.setTitleColor(UIColor(named: "green"), for: .normal)
                        //                        manualcross.setTypeface(font);
                        var sec : Int = Int(self.manualInfo["l" + String(mode) + "_second"]!)!// 0
                        sec = sec + 1; // 1
                        self.manualInfo["l" + String(mode) + "_second"]=String(sec)  // 1
                        var min = "0" + String(sec/60); // 0
                        var seconds = "0" + String(sec % 60); // 1
                        self.manualInfo["l" + String(mode)]=min.suffix(2) + ":" + seconds.suffix(2) // 00:01
                        self.manualTime1.text = self.manualInfo["l"+String(mode)]
                    }
                }
                RunLoop.current.add(countDownTimermode1, forMode: RunLoop.Mode.common)
                
            }
            
        }else if (mode==2)
        {
            if(stop)
            {
                if(countDownTimermode2.isValid)
                {
                    countDownTimermode2.invalidate()
                    self.manualCross2.setTitle("", for: .normal)
                    self.manualCross2.setTitleColor(UIColor(named: "red"), for: .normal)
                    self.manualTime2.text = Language.getInstance().getlangauge(key: "off")
                }
                
            }else
            {

                self.manualCross2.setTitle("", for: .normal)
                self.manualCross2.setTitleColor(UIColor(named: "green"), for: .normal)
                //                        manualcross.setTypeface(font);
                var sec : Int = Int(self.manualInfo["l" + String(mode) + "_second"]!)!// 0
                sec = sec + 1; // 1
                self.manualInfo["l" + String(mode) + "_second"]=String(sec)  // 1
                var min = "0" + String(sec/60); // 0
                var seconds = "0" + String(sec % 60); // 1
                self.manualInfo["l" + String(mode)]=min.suffix(2) + ":" + seconds.suffix(2) // 00:01
                self.manualTime2.text = self.manualInfo["l"+String(mode)]
                countDownTimermode2 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)
                 { (Timer) in
                     
                     self.manualCross2.setTitle("", for: .normal)
                     self.manualCross2.setTitleColor(UIColor(named: "green"), for: .normal)
                     //                        manualcross.setTypeface(font);
                     var sec : Int = Int(self.manualInfo["l" + String(mode) + "_second"]!)!// 0
                     sec = sec + 1; // 1
                     self.manualInfo["l" + String(mode) + "_second"]=String(sec)  // 1
                     var min = "0" + String(sec/60); // 0
                     var seconds = "0" + String(sec % 60); // 1
                     self.manualInfo["l" + String(mode)]=min.suffix(2) + ":" + seconds.suffix(2) // 00:01
                     self.manualTime2.text = self.manualInfo["l"+String(mode)]
                 }
                 RunLoop.current.add(countDownTimermode2, forMode: RunLoop.Mode.common)
                 
            }
            
        }else if (mode==3)
        {
            if(stop)
            {
                
                if(countDownTimermode3.isValid)
                {
                    countDownTimermode3.invalidate()
                    self.manualCross3.setTitle("", for: .normal)
                    self.manualCross3.setTitleColor(UIColor(named: "red"), for: .normal)
                    self.manualTime3.text = Language.getInstance().getlangauge(key: "off")
                }
            }else
            {

                countDownTimermode3 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)
                 { (Timer) in
                     
                     self.manualCross3.setTitle("", for: .normal)
                     self.manualCross3.setTitleColor(UIColor(named: "green"), for: .normal)
                     //                        manualcross.setTypeface(font);
                     var sec : Int = Int(self.manualInfo["l" + String(mode) + "_second"]!)!// 0
                     sec = sec + 1; // 1
                     self.manualInfo["l" + String(mode) + "_second"]=String(sec)  // 1
                     var min = "0" + String(sec/60); // 0
                     var seconds = "0" + String(sec % 60); // 1
                     self.manualInfo["l" + String(mode)]=min.suffix(2) + ":" + seconds.suffix(2) // 00:01
                     self.manualTime3.text = self.manualInfo["l"+String(mode)]
                 }
                 RunLoop.current.add(countDownTimermode3, forMode: RunLoop.Mode.common)
                 
            }
            
        }else if (mode==4)
        {
            if(stop)
            {
                
                if(countDownTimermode4.isValid)
                {
                    countDownTimermode4.invalidate()
                    self.manualCross4.setTitle("", for: .normal)
                    self.manualCross4.setTitleColor(UIColor(named: "red"), for: .normal)
                    self.manualTime4.text = Language.getInstance().getlangauge(key: "off")
                }
            }else
            {
                countDownTimermode4 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)
                                { (Timer) in
                                    
                                    self.manualCross4.setTitle("", for: .normal)
                                    self.manualCross4.setTitleColor(UIColor(named: "green"), for: .normal)
                                    //                        manualcross.setTypeface(font);
                                    var sec : Int = Int(self.manualInfo["l" + String(mode) + "_second"]!)!// 0
                                    sec = sec + 1; // 1
                                    self.manualInfo["l" + String(mode) + "_second"]=String(sec)  // 1
                                    var min = "0" + String(sec/60); // 0
                                    var seconds = "0" + String(sec % 60); // 1
                                    self.manualInfo["l" + String(mode)]=min.suffix(2) + ":" + seconds.suffix(2) // 00:01
                                    self.manualTime4.text = self.manualInfo["l"+String(mode)]
                                }
                                RunLoop.current.add(countDownTimermode4, forMode: RunLoop.Mode.common)
            }
            
        }else if (mode==5)
        {
            if(stop)
            {
             
                if(countDownTimermode5.isValid)
                {
                    countDownTimermode5.invalidate()
                    self.manualCross5.setTitle("", for: .normal)
                    self.manualCross5.setTitleColor(UIColor(named: "red"), for: .normal)
                    self.manualTime5.text = Language.getInstance().getlangauge(key: "off")
                }
            }else
            {
                countDownTimermode5 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)
                                { (Timer) in
                                    
                                    self.manualCross5.setTitle("", for: .normal)
                                    self.manualCross5.setTitleColor(UIColor(named: "green"), for: .normal)
                                    //                        manualcross.setTypeface(font);
                                    var sec : Int = Int(self.manualInfo["l" + String(mode) + "_second"]!)!// 0
                                    sec = sec + 1; // 1
                                    self.manualInfo["l" + String(mode) + "_second"]=String(sec)  // 1
                                    var min = "0" + String(sec/60); // 0
                                    var seconds = "0" + String(sec % 60); // 1
                                    self.manualInfo["l" + String(mode)]=min.suffix(2) + ":" + seconds.suffix(2) // 00:01
                                    self.manualTime5.text = self.manualInfo["l"+String(mode)]
                                }
                                RunLoop.current.add(countDownTimermode5, forMode: RunLoop.Mode.common)
            }
            
        }else if (mode==6)
        {
            if(stop)
            {
                if(countDownTimermode6.isValid)
                {
                    countDownTimermode6.invalidate()
                    self.manualCross6.setTitle("", for: .normal)
                    self.manualCross6.setTitleColor(UIColor(named: "red"), for: .normal)
                    self.manualTime6.text = Language.getInstance().getlangauge(key: "off")
                }
                
            }else
            {
                countDownTimermode6 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)
                                { (Timer) in
                                    
                                    self.manualCross6.setTitle("", for: .normal)
                                    self.manualCross6.setTitleColor(UIColor(named: "green"), for: .normal)
                                    //                        manualcross.setTypeface(font);
                                    var sec : Int = Int(self.manualInfo["l" + String(mode) + "_second"]!)!// 0
                                    sec = sec + 1; // 1
                                    self.manualInfo["l" + String(mode) + "_second"]=String(sec)  // 1
                                    var min = "0" + String(sec/60); // 0
                                    var seconds = "0" + String(sec % 60); // 1
                                    self.manualInfo["l" + String(mode)]=min.suffix(2) + ":" + seconds.suffix(2) // 00:01
                                    self.manualTime6.text = self.manualInfo["l"+String(mode)]
                                }
                                RunLoop.current.add(countDownTimermode6, forMode: RunLoop.Mode.common)
            }
            
        }else if (mode==7)
        {
            if(stop)
            {
                if(countDownTimermode7.isValid)
                {
                    countDownTimermode7.invalidate()
                    self.manualCross7.setTitle("", for: .normal)
                    self.manualCross7.setTitleColor(UIColor(named: "red"), for: .normal)
                    self.manualTime7.text = Language.getInstance().getlangauge(key: "off")
                }
                
            }else
            {
                countDownTimermode7 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)
                                { (Timer) in
                                    
                                    self.manualCross7.setTitle("", for: .normal)
                                    self.manualCross7.setTitleColor(UIColor(named: "green"), for: .normal)
                                    //                        manualcross.setTypeface(font);
                                    var sec : Int = Int(self.manualInfo["l" + String(mode) + "_second"]!)!// 0
                                    sec = sec + 1; // 1
                                    self.manualInfo["l" + String(mode) + "_second"]=String(sec)  // 1
                                    var min = "0" + String(sec/60); // 0
                                    var seconds = "0" + String(sec % 60); // 1
                                    self.manualInfo["l" + String(mode)]=min.suffix(2) + ":" + seconds.suffix(2) // 00:01
                                    self.manualTime7.text = self.manualInfo["l"+String(mode)]
                                }
                                RunLoop.current.add(countDownTimermode7, forMode: RunLoop.Mode.common)
            }
            
        }
        
    }
    
    
    
    func output_std(value:String)  {
        ControllerconnectionImpl.getInstance().requestSet(key: "manual.output_std", value: value, encryptionMode: "-")
        { (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                
            }
            else
            {
               print("out send")
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
