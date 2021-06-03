//
//  FirmwareUpdateViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 16/10/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit
import MBProgressHUD

class FirmwareUpdateViewController: UIViewController {
    var restartTimer:Timer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func newfirmware(_ sender: RoundButton) {
//        print("new")
        UpdateFirmware(payload: "new")
    }
    
    @IBAction func oldFirmware(_ sender: RoundButton) {
//        print("old")
        UpdateFirmware(payload: "old")
    }
    @IBAction func finishButton(_ sender: Any) {
        dismiss(animated: true)
    }
   func UpdateFirmware(payload: String) {
    let alert = UIAlertController(title: "", message: Language.getInstance().getlangauge(key: "update_firmware"), preferredStyle: UIAlertController.Style.alert)
          
          // add the actions (buttons)
    alert.addAction(UIAlertAction(title: Language.getInstance().getlangauge(key: "cancel"), style: UIAlertAction.Style.destructive, handler: nil))
    alert.addAction(UIAlertAction(title: Language.getInstance().getlangauge(key: "install"), style: UIAlertAction.Style.default, handler:
              { action in
                  self.startfirmware(neworold: payload)
                
          }))
          
          // show the alert
          self.present(alert, animated: true, completion: nil)
      }
    func startfirmware(neworold:String) ->  Void {
        UIApplication.shared.isIdleTimerDisabled = true
              let packetSize = 512
        var filePath :String!
        if(neworold == "new")
        {
            filePath = Bundle.main.path(forResource: "bbq_2_50_u.dat", ofType: nil)
        }else
        {
            filePath = Bundle.main.path(forResource: "bbq_2_50_u.dat", ofType: nil)
        }
                     
                    let nsdata = NSData(contentsOfFile: filePath!)
                    let stream: InputStream = InputStream(data: nsdata! as Data)
                    
                    let sendCount = nsdata!.length / packetSize;
                    let remain = nsdata!.length % packetSize
                    print(nsdata!.length)
                    print(String (sendCount))
                    print(String(remain))
                    stream.open()
                    let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
                    loadingNotification.mode = MBProgressHUDMode.annularDeterminate
            //        loadingNotification.label.text = "Loading"
                    loadingNotification.detailsLabel.text = "Updating Firmware"
                    if (stream.hasBytesAvailable){
                        var buffer = [UInt8](repeating: 0, count: nsdata!.length)
                        //                     let length1 = stream.read(&buffer, maxLength: buffer.count)
                        stream.read(&buffer, maxLength: buffer.count)
                        //                        if(length1 > 0){
                        let data = Data(_: buffer)
                        let bytesdata=data.toArray(type: UInt8.self)
                        var k=0
    //                    concurrentQueue.async(flags:.barrier) {
    //                        self.recursive(start: 0, max: sendCount, bytesdata: bytesdata,packetSize: packetSize,remain: remain,totalLength: String(nsdata!.length),loader: loadingNotification)
    //                    }

                        self.recursive2(start: 0, max: sendCount, bytesdata: bytesdata,packetSize: packetSize,remain: remain,totalLength: String(nsdata!.length),loader: loadingNotification)
                       
                    }else
                    {
//                        starthandler()
                        loadingNotification.hide(animated: true)
                        print("no bytes")
                    }
        }
      func recursive2(start:Int,max:Int,bytesdata:[UInt8],packetSize:Int,remain:Int,totalLength:String,loader:MBProgressHUD)
          {
              if(start<max){
                  let fromIndex = start * packetSize
                  let bytesbuffer = bytesdata[fromIndex..<(fromIndex + packetSize)]
                  var offset = String(start * packetSize + 1000000)
                  offset = String(offset.dropFirst())
                  var fullbuffer : [UInt8] = [UInt8]()
                  let finaloffset : [UInt8] = Array(offset.utf8)
                  fullbuffer.append(contentsOf: finaloffset)
                  fullbuffer.append(contentsOf: bytesbuffer)
                  var xorcheck : UInt8 = 0
                  for k in 0..<fullbuffer.count
                  {
                      xorcheck = xorcheck ^ fullbuffer[k]
                  }
                  fullbuffer.append(xorcheck)
                  print("-------------------")
                  var totalsend=Float(offset)
                  var totallengthinfloat=Float(totalLength)
                  loader.progress=totalsend!/totallengthinfloat!
                var stringprogress=Int((totalsend!/totallengthinfloat!)*100)
                loader.detailsLabel.text=String(stringprogress)+"%"
                  ControllerconnectionImpl.getInstance().requestSetFirmwareUpdate(key: "misc.push_version", value: fullbuffer, encryptionMode: " ") { (ControllerResponseImpl) in
                      if(ControllerResponseImpl.getStatusCode()=="0")
                      {
    //                      print("got response")
                        print("success start value perfore \(start) : after increment \(start+1)")
                          self.recursive2(start: start+1, max: max, bytesdata: bytesdata, packetSize: packetSize,remain: remain,totalLength: totalLength,loader: loader)
                      }else
                      {
    //                      print("got error")
                        print("error happen start value \(start) : now sending again \(start)")
                          self.recursive2(start: start, max: max, bytesdata: bytesdata, packetSize: packetSize,remain: remain,totalLength: totalLength,loader:loader)
                          
                      }
                  }
              }
              if(start>=max)
              {
                  print("last bytes")
                  //            last bytes here
                  let fromIndex = max * packetSize
                  let bytesbuffer = bytesdata[fromIndex..<(fromIndex + remain)]
                  var offset = String(max * packetSize + 1000000)
                  offset = String(offset.dropFirst())
                  var fullbuffer : [UInt8] = [UInt8]()
                  let finaloffset : [UInt8] = Array(offset.utf8)
                  fullbuffer.append(contentsOf: finaloffset)
                  fullbuffer.append(contentsOf: bytesbuffer)
                  var xorcheck : UInt8 = 0
                  for k in 0..<fullbuffer.count
                  {
                      xorcheck = xorcheck ^ fullbuffer[k]
                  }
                  fullbuffer.append(xorcheck)
                  print(fullbuffer.count)
                  var totalsend=Float(offset)
                  var totallengthinfloat=Float(totalLength)
                  loader.progress=totalsend!/totallengthinfloat!
                  ControllerconnectionImpl.getInstance().requestSetFirmwareUpdate(key: "misc.push_version", value: fullbuffer, encryptionMode: " ")
                  {
                      (ControllerResponseImpl) in
                      
                      if(ControllerResponseImpl.getStatusCode()=="0")
                      {
                          print("last bytes got response")
                        
                          ControllerconnectionImpl.getInstance().requestSet(key: "misc.push_prog_size", value: totalLength, encryptionMode: "-")
                          {
                              (ControllerResponseImpl) in
                            UIApplication.shared.isIdleTimerDisabled = false
                            self.restartTimerfuncrtion()
                              if(ControllerResponseImpl.getStatusCode()=="0")
                              {
                                  print(" final of size got response")
//                                  self.starthandler()
                                  loader.hide(animated: true)
                              }else
                              {
                                  print("got error")
//                                   self.starthandler()
                                  loader.hide(animated: true)
                              }
                          }
                      }else
                      {
                          print("got error")
//                           self.starthandler()
                          loader.hide(animated: true)
                      }
                  }
              }
          }
    func restartTimerfuncrtion()
    {
        if(restartTimer == nil)
        {
            var loadingNotification : MBProgressHUD!
            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = Language.getInstance().getlangauge(key: "lng_afterUpdate")
            restartTimer = Timer.scheduledTimer(withTimeInterval: 70, repeats: false) {
                (Timer) in
                loadingNotification.hide(animated: true)
                self.resetphone()
                
            }
            RunLoop.current.add(restartTimer, forMode: .common)
        }
    }
    func resetphone()   {
        Util.SetDefaultsBool(key: "setWakeLock", value: true)

        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "LanguageViewController") as? LanguageViewController else { return}

        sVC.modalPresentationStyle = .fullScreen
       self.present(sVC, animated: true)
    }
}
