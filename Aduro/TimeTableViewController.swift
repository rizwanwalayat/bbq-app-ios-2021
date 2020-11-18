//
//  TimeTableViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 22/07/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit
import MBProgressHUD

class TimeTableViewController: UIViewController {

    
    var arr = Array(repeating: Array(repeating: 0, count: 2), count: 3)

    var originalarray=Array(repeating: (Array(repeating: "0", count: 7)), count: 24)
    var changearray = Array(repeating: (Array(repeating: "0", count: 7)), count: 24)
    var viewarray = Array(repeating:Array(repeating: UIButton.init(), count: 7), count: 24)
//    var viewarray:[UIButton]=[UIButton]()
    @IBOutlet weak var one: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var four: UIButton!
    @IBOutlet weak var five: UIButton!
    @IBOutlet weak var six: UIButton!
    @IBOutlet weak var seven: UIButton!
    @IBOutlet weak var eight: UIButton!
    @IBOutlet weak var nine: UIButton!
    @IBOutlet weak var ten: UIButton!
    @IBOutlet weak var eleven: UIButton!
    @IBOutlet weak var twelve: UIButton!
    @IBOutlet weak var thirteen: UIButton!
    @IBOutlet weak var fourteen: UIButton!
    @IBOutlet weak var fifteen: UIButton!
    @IBOutlet weak var sixteen: UIButton!
    @IBOutlet weak var seventeen: UIButton!
    @IBOutlet weak var eighteen: UIButton!
    @IBOutlet weak var nineteen: UIButton!
    @IBOutlet weak var twenty: UIButton!
    @IBOutlet weak var twentyone: UIButton!
    @IBOutlet weak var twentytwo: UIButton!
    @IBOutlet weak var twentythree: UIButton!
    @IBOutlet weak var twentyfour: UIButton!
    @IBOutlet weak var twenty5: UIButton!
    @IBOutlet weak var twenty6: UIButton!
    @IBOutlet weak var twenty7: UIButton!
    @IBOutlet weak var twenty8: UIButton!
    @IBOutlet weak var twenty9: UIButton!
    @IBOutlet weak var thirty: UIButton!
    @IBOutlet weak var thirty1: UIButton!
    @IBOutlet weak var thirty2: UIButton!
    @IBOutlet weak var thirty3: UIButton!
    @IBOutlet weak var thirty4: UIButton!
    @IBOutlet weak var thirty5: UIButton!
    @IBOutlet weak var thirty6: UIButton!
    @IBOutlet weak var thirty7: UIButton!
    @IBOutlet weak var thirty8: UIButton!
    @IBOutlet weak var thirty9: UIButton!
    @IBOutlet weak var fourty: UIButton!
    @IBOutlet weak var fourty1: UIButton!
    @IBOutlet weak var fourt2: UIButton!
    @IBOutlet weak var fourty3: UIButton!
    @IBOutlet weak var fourty4: UIButton!
    @IBOutlet weak var fourty5: UIButton!
    @IBOutlet weak var fourty6: UIButton!
    @IBOutlet weak var fourty7: UIButton!
    @IBOutlet weak var fourty8: UIButton!
    @IBOutlet weak var fourty9: UIButton!
    @IBOutlet weak var fifty: UIButton!
    @IBOutlet weak var fifty1: UIButton!
    @IBOutlet weak var fifty2: UIButton!
    @IBOutlet weak var fifty3: UIButton!
    @IBOutlet weak var fifty4: UIButton!
    @IBOutlet weak var fifty5: UIButton!
    @IBOutlet weak var fifty6: UIButton!
    @IBOutlet weak var fifty7: UIButton!
    @IBOutlet weak var fifty8: UIButton!
    @IBOutlet weak var fifty9: UIButton!
    @IBOutlet weak var sixty: UIButton!
    @IBOutlet weak var sixty1: UIButton!
    @IBOutlet weak var sixty2: UIButton!
    @IBOutlet weak var sixty3: UIButton!
    @IBOutlet weak var sixty4: UIButton!
    @IBOutlet weak var sixty5: UIButton!
    @IBOutlet weak var sixty6: UIButton!
    @IBOutlet weak var sixty7: UIButton!
    @IBOutlet weak var sixty8: UIButton!
    @IBOutlet weak var sixty9: UIButton!
    @IBOutlet weak var seventy: UIButton!
    @IBOutlet weak var seventy1: UIButton!
    @IBOutlet weak var seventy2: UIButton!
    @IBOutlet weak var seventy3: UIButton!
    @IBOutlet weak var seventy4: UIButton!
    @IBOutlet weak var seventy5: UIButton!
    @IBOutlet weak var seventy6: UIButton!
    @IBOutlet weak var seventy7: UIButton!
    @IBOutlet weak var seventy8: UIButton!
    @IBOutlet weak var seventy9: UIButton!
    @IBOutlet weak var eighty: UIButton!
    @IBOutlet weak var eighty1: UIButton!
    @IBOutlet weak var eighty2: UIButton!
    @IBOutlet weak var eighty3: UIButton!
    @IBOutlet weak var eighty4: UIButton!
    @IBOutlet weak var eighty5: UIButton!
    @IBOutlet weak var eighty6: UIButton!
    @IBOutlet weak var eighty7: UIButton!
    @IBOutlet weak var eighty8: UIButton!
    @IBOutlet weak var eighty9: UIButton!
    @IBOutlet weak var ninty: UIButton!
    @IBOutlet weak var ninty1: UIButton!
    @IBOutlet weak var ninty2: UIButton!
    @IBOutlet weak var ninty3: UIButton!
    @IBOutlet weak var ninty4: UIButton!
    @IBOutlet weak var ninty5: UIButton!
    @IBOutlet weak var ninty6: UIButton!
    @IBOutlet weak var ninty7: UIButton!
    @IBOutlet weak var ninty8: UIButton!
    @IBOutlet weak var ninty9: UIButton!
    @IBOutlet weak var hundred: UIButton!
    @IBOutlet weak var hundred1: UIButton!
    @IBOutlet weak var hundred2: UIButton!
    @IBOutlet weak var hundred3: UIButton!
    @IBOutlet weak var hundred4: UIButton!
    @IBOutlet weak var hundred5: UIButton!
    @IBOutlet weak var hundred6: UIButton!
    @IBOutlet weak var hundred7: UIButton!
    @IBOutlet weak var hundred8: UIButton!
    @IBOutlet weak var hundred9: UIButton!
    @IBOutlet weak var hundred10: UIButton!
    @IBOutlet weak var hundred11: UIButton!
    @IBOutlet weak var hundred12: UIButton!
    @IBOutlet weak var hundred13: UIButton!
    @IBOutlet weak var hundred14: UIButton!
    @IBOutlet weak var hundred15: UIButton!
    @IBOutlet weak var hundred16: UIButton!
    @IBOutlet weak var hundred17: UIButton!
    @IBOutlet weak var hundred18: UIButton!
    @IBOutlet weak var hundred19: UIButton!
    @IBOutlet weak var hundred20: UIButton!
    @IBOutlet weak var hundred21: UIButton!
    @IBOutlet weak var hundred22: UIButton!
    @IBOutlet weak var hundred23: UIButton!
    @IBOutlet weak var hundred24: UIButton!
    @IBOutlet weak var hundred25: UIButton!
    @IBOutlet weak var hundred26: UIButton!
    @IBOutlet weak var hundred27: UIButton!
    @IBOutlet weak var hundred28: UIButton!
    @IBOutlet weak var hundred29: UIButton!
    @IBOutlet weak var hundred30: UIButton!
    @IBOutlet weak var hundred31: UIButton!
    @IBOutlet weak var hundred32: UIButton!
    @IBOutlet weak var hundred33: UIButton!
    @IBOutlet weak var hundred34: UIButton!
    @IBOutlet weak var hundred35: UIButton!
    @IBOutlet weak var hundred36: UIButton!
    @IBOutlet weak var hundred37: UIButton!
    @IBOutlet weak var hundred38: UIButton!
    @IBOutlet weak var hundred39: UIButton!
    @IBOutlet weak var hundred40: UIButton!
    @IBOutlet weak var hundred41: UIButton!
    @IBOutlet weak var hundred42: UIButton!
    @IBOutlet weak var hundred43: UIButton!
    @IBOutlet weak var hundred44: UIButton!
    @IBOutlet weak var hundred45: UIButton!
    @IBOutlet weak var hundred46: UIButton!
    @IBOutlet weak var hundred47: UIButton!
    @IBOutlet weak var hundred48: UIButton!
    @IBOutlet weak var hundred49: UIButton!
    @IBOutlet weak var hundred50: UIButton!
    @IBOutlet weak var hundred51: UIButton!
    @IBOutlet weak var hundred52: UIButton!
    @IBOutlet weak var hundred53: UIButton!
    @IBOutlet weak var hundred54: UIButton!
    @IBOutlet weak var hundred55: UIButton!
    @IBOutlet weak var hundred56: UIButton!
    @IBOutlet weak var hundred57: UIButton!
    @IBOutlet weak var hundred58: UIButton!
    @IBOutlet weak var hundred59: UIButton!
    @IBOutlet weak var hundred60: UIButton!
    @IBOutlet weak var hundred61: UIButton!
    @IBOutlet weak var hundred62: UIButton!
    @IBOutlet weak var hundred63: UIButton!
    @IBOutlet weak var hundred64: UIButton!
    @IBOutlet weak var hundred65: UIButton!
    @IBOutlet weak var hundred66: UIButton!
    @IBOutlet weak var hundred67: UIButton!
    @IBOutlet weak var hundred68: UIButton!
    
    
    @IBOutlet weak var monday: UIButton!
    @IBOutlet weak var tuesday: UIButton!
    @IBOutlet weak var wednesday: UIButton!
    @IBOutlet weak var thursday: UIButton!
    @IBOutlet weak var friday: UIButton!
    @IBOutlet weak var saturday: UIButton!
    @IBOutlet weak var sunday: UIButton!
    let concurrentQueue = DispatchQueue(label: "time Queue", attributes: .concurrent)

    override func viewDidLoad() {
        super.viewDidLoad()

        monday.setTitle(Language.getInstance().getlangauge(key: "mon"), for: .normal)
        tuesday.setTitle(Language.getInstance().getlangauge(key: "tue"), for: .normal)
        wednesday.setTitle(Language.getInstance().getlangauge(key: "wed"), for: .normal)
        thursday.setTitle(Language.getInstance().getlangauge(key: "thu"), for: .normal)
        friday.setTitle(Language.getInstance().getlangauge(key: "fri"), for: .normal)
        saturday.setTitle(Language.getInstance().getlangauge(key: "sat"), for: .normal)
        sunday.setTitle(Language.getInstance().getlangauge(key: "sun"), for: .normal)
        // Do any additional setup after loading the view.
        setarray()
        concurrentQueue.async(flags:.barrier) {
            self.getValue(key: "boiler.monday_24")
        }
        concurrentQueue.async(flags:.barrier) {
            self.getValue(key: "boiler.tuesday_24")
        }
        concurrentQueue.async(flags:.barrier) {
            self.getValue(key: "boiler.wednesday_24")
        }
        concurrentQueue.async(flags:.barrier) {
            self.getValue(key: "boiler.thursday_24")

        }
        concurrentQueue.async(flags:.barrier) {
            self.getValue(key: "boiler.friday_24")
        }
        concurrentQueue.async(flags:.barrier) {
            self.getValue(key: "boiler.saturday_24")
        }
        concurrentQueue.async(flags:.barrier) {
            self.getValue(key: "boiler.sunday_24")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        saveTimetableToController(showprogress: false)
    }
    @IBAction func finish(_ sender: UIButton) {
        self.dismiss(animated: true)
        
            }
    
    @IBAction func Save(_ sender: UIButton) {
        saveTimetableToController(showprogress: true)
    }
    
    @IBAction func Refresh(_ sender: UIButton) {
        revert()
    }
    
    @IBAction func fire(_ sender: UIButton) {
        completeChange(value: "0")
    }
    @IBAction func ThermoMeter(_ sender: UIButton) {
        completeChange(value: "2")
    }
    
    @IBAction func stop(_ sender: UIButton) {
        completeChange(value: "1")
    }
    
    
    func getValue(key:String)  {
        var loadingNotification : MBProgressHUD!
        DispatchQueue.main.async {
            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = Language.getInstance().getlangauge(key: "loading")
            loadingNotification.detailsLabel.text = Language.getInstance().getlangauge(key:"please_wait")
             }
        ControllerconnectionImpl.getInstance().requestRead(key: key)
        { (ControllerResponseImpl) in
            DispatchQueue.main.async {
                             loadingNotification.hide(animated: true)
                         }
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
//                self.getValue(key: key)
            }else
            {
                if(key=="boiler.monday_24")
                {
                    self.setarray()
                    let stringfrompayload=ControllerResponseImpl.GetReadValue()["monday_24"]
                    let CharArray = Array(stringfrompayload!)
                    for (index,item) in CharArray.enumerated()
                    {
                        self.originalarray[index][0]=String(item)
                        self.changearray[index][0]=String(item)
                    }
                
                }
                else if(key=="boiler.tuesday_24")
                {
                    
                    let stringfrompayload=ControllerResponseImpl.GetReadValue()["tuesday_24"]
                    let CharArray = Array(stringfrompayload!)
                    for (index,item) in CharArray.enumerated()
                    {
                        self.originalarray[index][1]=String(item)
                        self.changearray[index][1]=String(item)
                    }
                    
                }
                else if(key=="boiler.wednesday_24")
                    
                {
                    
                    let stringfrompayload=ControllerResponseImpl.GetReadValue()["wednesday_24"]
                    let CharArray = Array(stringfrompayload!)
                    for (index,item) in CharArray.enumerated()
                    {
                        self.originalarray[index][2]=String(item)
                        self.changearray[index][2]=String(item)
                    }
                    
                }
                else if(key=="boiler.thursday_24")
                {
                    
                    let stringfrompayload=ControllerResponseImpl.GetReadValue()["thursday_24"]
                    let CharArray = Array(stringfrompayload!)
                    for (index,item) in CharArray.enumerated()
                    {
                        self.originalarray[index][3]=String(item)
                        self.changearray[index][3]=String(item)
                    }
                    
                }
                else if(key=="boiler.friday_24")
                {
                    
                    let stringfrompayload=ControllerResponseImpl.GetReadValue()["friday_24"]
                    let CharArray = Array(stringfrompayload!)
                    for (index,item) in CharArray.enumerated()
                    {
                        self.originalarray[index][4]=String(item)
                        self.changearray[index][4]=String(item)
                    }
                    
                }
                else if(key=="boiler.saturday_24")
                {
                    
                    let stringfrompayload=ControllerResponseImpl.GetReadValue()["saturday_24"]
                    let CharArray = Array(stringfrompayload!)
                    for (index,item) in CharArray.enumerated()
                    {
                        self.originalarray[index][5]=String(item)
                        self.changearray[index][5]=String(item)
                    }
                    
                }else if(key=="boiler.sunday_24")
                {
                    
                    let stringfrompayload=ControllerResponseImpl.GetReadValue()["sunday_24"]
                    let CharArray = Array(stringfrompayload!)
                    for (index,item) in CharArray.enumerated()
                    {
                        self.originalarray[index][6]=String(item)
                        self.changearray[index][6]=String(item)
                    }
                    
                    print("its done")
                    self.changeview()
                    
                }
            }
            
        }
    }
    func changeview()  {
        
        for (index, item) in changearray.enumerated()
        {
            for(innerindex, inneritem) in item.enumerated()
            {
                if(inneritem=="0")
                {
//                    var indexvalueofView:Int=0
                    viewarray[index][innerindex].backgroundColor=UIColor(named: "green")
                    
                }else if (inneritem=="1")
                {
                    
                    viewarray[index][innerindex].backgroundColor=UIColor(named: "red")
                }else if(inneritem=="2")
                {
                    
                    viewarray[index][innerindex].backgroundColor=UIColor(named: "blue")
                }
//                print("\(index) : \(innerindex) : \(inneritem)")
            }
            
        }
        
    }
    func completeChange(value:String)  {
        
        for (index, item) in changearray.enumerated()
        {
            for(innerindex, inneritem) in item.enumerated()
            {
                changearray[index][innerindex]=value
            }
        }
        changeview()
    }
    func revert()  {
        for (index, item) in originalarray.enumerated()
        {
            for(innerindex, inneritem) in item.enumerated()
            {
                changearray[index][innerindex]=originalarray[index][innerindex]
            }
        }
        changeview()
        
    }
    
    func saveTimetableToController(showprogress:Bool)  {
        
        
        if(originalarray as NSArray == changearray as NSArray)
        {
            print("same")
        }else
        {
            print("different")
            var mon:String="",tue:String="",wed:String="",thur:String="",fri:String="",sat:String="",sun:String=""
            for i in 0...6
            {
//                print(item)
                for (j, item) in changearray.enumerated()
                {
                    if(i==0)
                    {
                     mon = mon + changearray[j][i]
                    }else if(i==1)
                    {
                        tue=tue + changearray[j][i]
                    }else if(i==2)
                    {
                        wed = wed + changearray[j][i]
                    }else if(i==3)
                    {
                        thur = thur + changearray[j][i]
                    }else if(i==4)
                    {
                        fri = fri + changearray[j][i]
                    }else if(i==5)
                    {
                        sat = sat + changearray[j][i]
                    }else if(i==6)
                    {
                        sun = sun + changearray[j][i]
                    }
                }
            }
            concurrentQueue.async(flags:.barrier) {
                self.changevlaue(value: mon, key: "boiler.monday_24",showpregress: showprogress)
            }
            concurrentQueue.async(flags:.barrier) {
                self.changevlaue(value: tue, key: "boiler.tuesday_24",showpregress: showprogress)
            }
            concurrentQueue.async(flags:.barrier) {
                self.changevlaue(value: wed, key: "boiler.wednesday_24",showpregress: showprogress)
            }
            concurrentQueue.async(flags:.barrier) {
                self.changevlaue(value: thur, key: "boiler.thursday_24",showpregress: showprogress)
            }
            concurrentQueue.async(flags:.barrier) {
                self.changevlaue(value: fri, key: "boiler.friday_24",showpregress: showprogress)
            }
            concurrentQueue.async(flags:.barrier) {
                self.changevlaue(value: sat, key: "boiler.saturday_24",showpregress: showprogress)
            }
            concurrentQueue.async(flags:.barrier) {
                self.changevlaue(value: sun, key: "boiler.sunday_24",showpregress: showprogress)
            }
        }
        
    }
    
    
    func changevlaue(value:String,key:String,showpregress:Bool)
    {
        var loadingNotification : MBProgressHUD!

        if(showpregress)
        {
                 DispatchQueue.main.async {
                      loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                     loadingNotification.mode = MBProgressHUDMode.indeterminate
                     loadingNotification.label.text = Language.getInstance().getlangauge(key: "please_wait")
//                     loadingNotification.detailsLabel.text = Language.getInstance().getlangauge(key:"connecting")
                 }
        }
      
        ControllerconnectionImpl.getInstance().requestSet(key: key, value: value, encryptionMode: " ") { (ControllerResponseImpl) in
            
            if(showpregress)
            {
                
                DispatchQueue.main.async {
                    loadingNotification.hide(animated: true)
                }
            }
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
            }else
            {
                if(key=="boiler.monday_24")
                {
                }else if(key=="boiler.tuesday_24")
                {
                }else if(key=="boiler.wednesday_24")
                {
                }else if(key=="boiler.thursday_24")
                {
                }else if(key=="boiler.friday_24")
                {
                }else if(key=="boiler.saturday_24")
                {
                }else if(key=="boiler.sunday_24")
                {
                    print("its done")
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
    
    
    func setarray()  {
        
        viewarray = [
        [one,two,three,four,five,six,seven],
        [eight,nine,ten,eleven,twelve,thirteen, fourteen],
        [fifteen,sixteen,seventeen,eighteen,nineteen,twenty,twentyone],
        [twentytwo,twentythree,twentyfour,twenty5,twenty6,twenty7,twenty8],
        [twenty9,thirty,thirty1,thirty2,thirty3,thirty4,thirty5],
        [thirty6,thirty7,thirty8,thirty9,fourty,fourty1,fourt2],
        [fourty3,fourty4,fourty5,fourty6,fourty7,fourty8,fourty9],
        [fifty,fifty1,fifty2,fifty3,fifty4,fifty5,fifty6],
        [fifty7,fifty8,fifty9,sixty,sixty1,sixty2,sixty3],
        [sixty4,sixty5,sixty6,sixty7,sixty8,sixty9,seventy],
        [seventy1,seventy2,seventy3,seventy4,seventy5,seventy6,seventy7],
        [seventy8,seventy9,eighty,eighty1,eighty2,eighty3,eighty4],
        [eighty5,eighty6,eighty7,eighty8,eighty9,ninty,ninty1],
        [ninty2,ninty3,ninty4,ninty5,ninty6,ninty7,ninty8],
        [ninty9,hundred,hundred1,hundred2,hundred3,hundred4,hundred5],
        [hundred6,hundred7,hundred8,hundred9,hundred10,hundred11,hundred12],
        [hundred13,hundred14,hundred15,hundred16,hundred17,hundred18,hundred19],
        [hundred20,hundred21,hundred22,hundred23,hundred24,hundred25,hundred26],
        [hundred27,hundred28,hundred29,hundred30,hundred31,hundred32,hundred33],
        [hundred34,hundred35,hundred36,hundred37,hundred38,hundred39,hundred40],
        [hundred41,hundred42,hundred43,hundred44,hundred45,hundred46,hundred47],
        [hundred48,hundred49,hundred50,hundred51,hundred52,hundred53,hundred54],
        [hundred55,hundred56,hundred57,hundred58,hundred59,hundred60,hundred61],
        [hundred62,hundred63,hundred64,hundred65,hundred66,hundred67,hundred68]
        ]
        
        
        for(index, item) in viewarray.enumerated()
        {
            for (innderindex,inneritem) in item.enumerated()
            {
                let tagvalue=Int(String(index) + String(innderindex))
                inneritem.tag=tagvalue!
                inneritem.addTarget(self, action: #selector(self.onclickofsingletime(_:)), for: .touchUpInside)
            }
        }
    }
    
    @objc func onclickofsingletime(_ sender:UIButton)  {
        
        print(getrowCo(value: sender.tag))
        let rowcol=getrowCo(value: sender.tag)
        let row:Int=Int(rowcol.0)!
        let col:Int=Int(rowcol.1)!
        changearray[row][col] = String((Int(changearray[row][col])! + 1) % 3)
        changeview()
    }
    
    func getrowCo(value:Int) -> (String,String) {
        let temp=String(value)
        if(temp.count==1)
        {
            return ("0",temp)
        }else if(temp.count==2)
        {
            var a=Array(temp)
            return (String(a[0]),String(a[1]))
        }else if(temp.count==3)
        {
            var a=Array(temp)
            return (String(a[0])+String(a[1]),String(a[2]))
        }
        return ("0","0")
    }
    
    func changecolumnclolor(column:Int)  {
        
        for (index, item) in changearray.enumerated()
        {
            changearray[index][column]=String((Int(changearray[index][column])! + 1) % 3)
        }
        changeview()
    }
    func changeRowColor(row:Int)  {
        
        for (index,item) in changearray[row].enumerated()
        {
            changearray[row][index]=String((Int(changearray[row][index])! + 1) % 3)
        }
        changeview()
        
    }
    
    @IBAction func mondayclick(_ sender: Any) {
        changecolumnclolor(column: 0)
    }
    
    @IBAction func tuesday(_ sender: Any) {
        
        changecolumnclolor(column: 1)
    }
    
    @IBAction func wednesday(_ sender: Any) {
        
        changecolumnclolor(column: 2)
    }
    
    @IBAction func thursday(_ sender: Any) {
    
        changecolumnclolor(column: 3)
    }
    
    @IBAction func friday(_ sender: Any) {
    
        changecolumnclolor(column: 4)
    }
    
    @IBAction func sat(_ sender: Any) {
   
        changecolumnclolor(column: 5)
    }
    
    @IBAction func sunday(_ sender: Any) {
    
        changecolumnclolor(column: 6)
    }
    
    @IBAction func row1(_ sender: UIButton) {
        changeRowColor(row: 0)
    }
    
    @IBAction func row2(_ sender: UIButton) {
        changeRowColor(row: 1)

    }
    @IBAction func row3(_ sender: UIButton) {
        changeRowColor(row: 2)

    }
    
    @IBAction func row4(_ sender: Any) {
        changeRowColor(row: 3)

    }
    
    @IBAction func row5(_ sender: Any) {
        changeRowColor(row: 4)

    }
    
    @IBAction func row6(_ sender: Any) {
        changeRowColor(row: 5)

    }
    
    
    @IBAction func row7(_ sender: UIButton) {
        changeRowColor(row: 6)

        
    }
    
    @IBAction func row8(_ sender: UIButton) {
        changeRowColor(row: 7)

        
    }
    @IBAction func row9(_ sender: UIButton) {
        changeRowColor(row: 8)

        
    }
    @IBAction func row10(_ sender: UIButton) {
        changeRowColor(row: 9)

        
    }
    
    @IBAction func row11(_ sender: UIButton) {
        changeRowColor(row: 10)

        
    }
    @IBAction func row12(_ sender: UIButton) {
        changeRowColor(row: 11)

        
    }
    @IBAction func row13(_ sender: UIButton) {
        changeRowColor(row: 12)

        
    }
    @IBAction func row14(_ sender: UIButton) {
        changeRowColor(row: 13)

        
    }
    @IBAction func row15(_ sender: UIButton) {
        changeRowColor(row: 14)

        
    }
    @IBAction func row16(_ sender: UIButton) {
        changeRowColor(row: 15)

        
    }
    @IBAction func row17(_ sender: UIButton) {
        changeRowColor(row: 16)

        
    }
    @IBAction func row18(_ sender: UIButton) {
        changeRowColor(row: 17)

        
    }
    @IBAction func row19(_ sender: UIButton) {
        changeRowColor(row: 18)

        
    }
    @IBAction func row20(_ sender: UIButton) {
        changeRowColor(row: 19)

        
    }
    
    @IBAction func row21(_ sender: UIButton) {
        changeRowColor(row: 20)

    }
    @IBAction func row22(_ sender: UIButton) {
        changeRowColor(row: 21)

    }
    @IBAction func row23(_ sender: UIButton) {
        changeRowColor(row: 22)

    }
    @IBAction func row24(_ sender: UIButton) {
        changeRowColor(row: 23)

    }
    
    
    
    
    
    
    
    
    
}
