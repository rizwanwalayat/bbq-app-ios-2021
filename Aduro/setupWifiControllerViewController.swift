//
//  setupWifiControllerViewController.swift
//  BBQ
//
//  Created by Macbook Pro on 23/08/2019.
//  Copyright © 2019 Phaedra. All rights reserved.
//

import UIKit
import MBProgressHUD

@available(iOS 10.0, *)
class setupWifiControllerViewController: UIViewController , UITableViewDelegate, UITableViewDataSource,IWatchDogDelegate{

    let concurrentQueue = DispatchQueue(label: "wifi Queue", attributes: .concurrent)


    
    @IBOutlet weak var availableNetworkList: UILabel!
    @IBOutlet weak var enterSSIDlabel: UILabel!
    @IBOutlet weak var enterSSIDbtnLabel: UIButton!
    @IBOutlet weak var passwordWifiLabel: UILabel!
    @IBOutlet weak var passwordEnterbtnLabel: UIButton!
    @IBOutlet weak var connectOvenLabel: UILabel!
    @IBOutlet weak var WifiNnameLabel: UILabel!
    @IBOutlet weak var NetworkStatusLabel: UILabel!
    @IBOutlet weak var finishbtnLabel: UIButton!
    @IBOutlet weak var enterManuallyBtn: UIButton!
    
    
    
    @IBOutlet weak var passwordfield: UITextField!
    @IBOutlet weak var ssidfield: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var networkView: UIView!
    @IBOutlet weak var connectgrillview: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ssidView: UIView!
    @IBOutlet weak var networdbtn: UIButton!
    @IBOutlet weak var passwordbtn: UIButton!
    @IBOutlet weak var ssidbtn: UIButton!
    @IBOutlet weak var wifiName: UILabel!
    @IBOutlet weak var ConnectionStatus: UILabel!
    @IBOutlet weak var networkStatus: UILabel!
    @IBOutlet weak var connectbtnlabel: UIButton!
    @IBOutlet weak var currentNetwork: UILabel!
    var currentnetworkvale:String=""
    
    var tableData = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate=self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        passwordfield.addTarget(self, action: #selector(textFieldDidDone(_:)), for: UIControl.Event.editingDidEnd)

        connectgrillview.isHidden=true
        
    ssidView.isHidden=true
        passwordView.isHidden=true
        currentNetwork.text=Language.getInstance().getlangauge(key: "wifi_connect_current")+" "+currentnetworkvale
        // Do any additional setup after loading the view.
        WifiWatchDog.getInstance().registernetwork(delegate: self)
        
        availableNetworkList.text=Language.getInstance().getlangauge(key: "wifi_connect_search")
        enterSSIDlabel.text=Language.getInstance().getlangauge(key: "wifi_connect_ssid")
        enterSSIDbtnLabel.setTitle(Language.getInstance().getlangauge(key: "wifi_connect_continue"), for: .normal)
        passwordWifiLabel.text=Language.getInstance().getlangauge(key: "wifi_connect_password")
        passwordEnterbtnLabel.setTitle(Language.getInstance().getlangauge(key: "wifi_connect_continue"), for: .normal)
        connectOvenLabel.text=Language.getInstance().getlangauge(key: "wifi_connect")
        WifiNnameLabel.text=Language.getInstance().getlangauge(key: "wifi_connect_name_title")
        NetworkStatusLabel.text=Language.getInstance().getlangauge(key: "wifi_connect_status_title")
        enterManuallyBtn.setTitle(Language.getInstance().getlangauge(key: "wifi_connect_manual"), for: .normal)
        
        concurrentQueue.async(flags:.barrier) {

            self.start()
        }
    }
    
    @objc func textFieldDidDone(_ textField: UITextField) {
//        print("done password")
//        let serial = self.ssidfield.text!
//                       let password = self.passwordfield.text!
//                       let finalval = "\(serial),\(password)"
//
//                      print(finalval)
//        concurrentQueue.async(flags:.barrier) {
//
//            self.setWifiSendSerialAndPassword(finalvalue: finalval)
//        }
       
        
    }
    @IBAction func ssidcontinuebtn(_ sender: Any) {
        ssidView.isHidden=true
        ssidbtn.setTitle("+", for: .normal)
        passwordView.isHidden=false
        passwordbtn.setTitle("-", for: .normal)
        networkView.isHidden=true
        networdbtn.setTitle("+", for: .normal)

    }
    
    
    @IBAction func passwordcontinuebtn(_ sender: Any)
    {
        passwordfield.resignFirstResponder()
                let serial = self.ssidfield.text!
                let password = self.passwordfield.text!
                let finalval = "\(serial),\(password)"
               
               print(finalval)
        concurrentQueue.async(flags:.barrier) {

                   self.setWifiSendSerialAndPassword(finalvalue: finalval)
               }
        
    }
    func setWifiSendSerialAndPassword(finalvalue:String)
    {
       
        ControllerconnectionImpl.getInstance().reuqestSetWithoutEncrypt(key: "wifi.router", value: finalvalue) { (ControllerResponseImpl) in
            
            if(ControllerResponseImpl.getStatusCode() == "0")
            {
                self.networkView.isHidden=true
                self.networdbtn.setTitle("+", for: .normal)
                self.passwordView.isHidden=true
                self.passwordbtn.setTitle("+", for: .normal)
                self.ssidView.isHidden=true
                self.ssidbtn.setTitle("+", for: .normal)
                    self.checkWifiConnected()
                
            }else
            {
                
            }
            
        }
    }
    
    
    @IBAction func enterManualBTN(_ sender: RoundButton) {
        networkView.isHidden=true
        networdbtn.setTitle("+", for: .normal)
        ssidView.isHidden=false
        ssidbtn.setTitle("-", for: .normal)
    }
    
    func checkWifiConnected()
    {
        var loadingNotification : MBProgressHUD!
            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = Language.getInstance().getlangauge(key: "loading")
            loadingNotification.detailsLabel.text = Language.getInstance().getlangauge(key: "connectwifi")
        let timer = Timer.scheduledTimer(withTimeInterval: 40, repeats: true)
        { (timer) in
            // do stuff 42 seconds later
            
            self.concurrentQueue.async(flags:.barrier){
                ControllerconnectionImpl.getInstance().requestRead(key: "wifi.router", completionfinal: { (ControllerResponseImpl) in
                               if(ControllerResponseImpl.getPayload().contains("nothing"))
                               {
                                DispatchQueue.main.async {
                                    loadingNotification.hide(animated:true)
                                    timer.invalidate()
                                    self.connectgrillview.isHidden=false
                                }
                               }
                               else
                               {
                                
                                DispatchQueue.main.async {
                                    timer.invalidate()
                                        loadingNotification.hide(animated:true)
                                        print(ControllerResponseImpl.GetReadValue()["router"] as Any)
                                        self.connectgrillview.isHidden=false
                                        let array = ControllerResponseImpl.GetReadValue()["router"]?.split(separator: ",")
                                        if (String(array![1]) != "2")
                                        {
                                            self.networkStatus.text = "NO connection"
                                            self.ConnectionStatus.textColor = UIColor.red
                                            if(String(array![2]) == "1")
                                            {
                                             self.ConnectionStatus.text = "Timeout"
                                            } else if(String(array![2]) == "2")
                                            {
                                                self.ConnectionStatus.text = "Grill could not be connected - wrong password"
                                            }
                                            else if(String(array![2]) == "3")
                                            {
                                                self.ConnectionStatus.text = "Cannot find target AP (Wrong SSID)"
                                            }else if(String(array![2]) == "4")
                                            {
                                                self.ConnectionStatus.text = "Connection Failed"
                                            }
                                            self.connectbtnlabel.setTitle("Try again", for: .normal)
                                            
                                        }
                                        else
                                        {
                                            self.wifiName.text = String(array![0])
                                            self.ConnectionStatus.text = ""
                                            self.networkStatus.text = "Connected to Stokercloud"
                                            self.connectbtnlabel.setTitle("Finish", for: .normal)
                                            self.connectbtnlabel.backgroundColor = UIColor(red: 61/255, green: 203/255, blue: 100/255, alpha: 1.0)
                                        
                                    }
                                    
                                }
                                       
                                   
                               }
                           })
            }
           
            
        }
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    @IBAction func networklist(_ sender: Any) {
        self.connectgrillview.isHidden=true
        if(networkView.isHidden)
        {
            networkView.isHidden=false
            networdbtn.setTitle("-", for: .normal)
            ssidView.isHidden=true
            ssidbtn.setTitle("+", for: .normal)
            passwordView.isHidden=true
            passwordbtn.setTitle("+", for: .normal)
        }
        else
        {
            networkView.isHidden=true
            networdbtn.setTitle("+", for: .normal)
        }
    }
    @IBAction func SSIDButton(_ sender: Any)
    {
        self.connectgrillview.isHidden=true
        if(ssidView.isHidden)
        {
            ssidView.isHidden=false
            ssidbtn.setTitle("-", for: .normal)
            passwordView.isHidden=true
            passwordbtn.setTitle("+", for: .normal)
            networkView.isHidden=true
            networdbtn.setTitle("+", for: .normal)
        }else{
            ssidView.isHidden=true
            ssidbtn.setTitle("+", for: .normal)
        }
    }
    @IBAction func Passwordbutt(_ sender: Any)
    {
        self.connectgrillview.isHidden=true
        if(passwordView.isHidden)
        {
            ssidView.isHidden=true
            ssidbtn.setTitle("+", for: .normal)
            passwordView.isHidden=false
            passwordbtn.setTitle("-", for: .normal)
            networkView.isHidden=true
            networdbtn.setTitle("+", for: .normal)
        }else{
            passwordView.isHidden=true
            passwordbtn.setTitle("+", for: .normal)
        }
    }
    
    
    @IBAction func connectButton(_ sender: UIButton) {
        if(sender.title(for: .normal) == "Finish")
        {
            
            guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                else
            {
                    return
                
            }
            sVC.serial=Util.GetDefaultsString(key: Constants.serialKey)
            sVC.password=Util.GetDefaultsString(key: Constants.passwordKey)
            sVC.fromSplash=false
            WifiWatchDog.getInstance().unRegisterMonitor()
            self.present(sVC, animated: true)
        }
        else
        {
            WifiWatchDog.getInstance().unRegisterMonitor()
           self.dismiss(animated: true)
        }
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        WifiWatchDog.getInstance().unRegisterMonitor()
        self.dismiss(animated: true)
    }
    func start()
    {
        var loadingNotification:MBProgressHUD!
        DispatchQueue.main.async {
            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                 loadingNotification.mode = MBProgressHUDMode.indeterminate
                 loadingNotification.label.text = Language.getInstance().getlangauge(key: "loading")
                 loadingNotification.detailsLabel.text = Language.getInstance().getlangauge(key: "connecting")
        }
    
        ControllerconnectionImpl.getInstance().reuqestSetWithoutEncrypt(key: "wifi.networklist", value: "1")
        {
            (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
                //                print("error")
                //                self.showToast(message: "TimeOut Error Try Again")
                DispatchQueue.main.async {
                
                    loadingNotification.hide(animated: true)
                }
            }
            else
            {
                let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true)
                { (timer) in
                    // do stuff 42 seconds later

                    self.concurrentQueue.async(flags:.barrier) {
                        ControllerconnectionImpl.getInstance().requestRead(key: "wifi.networklist", completionfinal: { (ControllerResponseImpl) in
                                                if(ControllerResponseImpl.getPayload().contains("nothing"))
                                                {
                                                    //                print("error")
                                                    //                self.showToast(message: "TimeOut Error Try Again")
                                                    loadingNotification.hide(animated:true)
                                                    print("got no list")
                                                    timer.invalidate()
                                                }
                                                else
                                                {
                                                    timer.invalidate()
                                                    loadingNotification.hide(animated:true)
                                                    
                        //                            print("first key " + String(Array(ControllerResponseImpl.GetReadValue().keys)[0]))
                                                    for value in Array(ControllerResponseImpl.GetReadValue().keys)
                                                    {
                                                        self.tableData.append(value.replacingOccurrences(of: "\"", with: ""))
                                                    }
                                                    print(self.tableData as Any)
                                                    self.tableView.reloadData()
                                                }
                                            })
                    }
                    
                }
                RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
             
            }
           
            
        }
    }
   
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        print(tableView.cellForRow(at: indexPath)?.textLabel?.text)
        networkView.isHidden=true
        networdbtn.setTitle("+", for: .normal)
        ssidView.isHidden=false
        ssidbtn.setTitle("-", for: .normal)
        ssidfield.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = tableData[row]
//        cell.textLabel?.textColor = UIColor.red
//        tableView:didEndDisplayingCell:forRowAtIndexPath:
        cell.selectionStyle = .none
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func refreshWifiList(_ sender: UIButton) {
        start()
    }
    
   
    
    
    func onLost() {
        print("lost")
    }
    
    func onAvailable() {
        print("Got network")
        if(Util.GetSSID().contains("Aduro"))
        {
            print("on Aduro")
//            showDialog()
        }
        else
        {
            print("wrong SSID \(Util.GetSSID())")
            if(Util.GetDefaultsBool(key: Constants.directConnectFlag))
            {
                showDialog()
                print("show Dialog")
            }
        }
    }
    
    func  showDialog()  {
        
           DispatchQueue.main.async {
        let alert = UIAlertController(title: "Wifi Changed", message: "Wifi Is not connected to Aduro-\(Util.GetDefaultsString(key: Constants.serialKey))", preferredStyle: .alert)
        alert.dismiss(animated: true)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
        }
    }
}
