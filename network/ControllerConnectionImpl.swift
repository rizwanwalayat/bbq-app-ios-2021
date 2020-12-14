//
//  ControllerConnectionImpl.swift
//  BBQ
//
//  Created by Macbook Pro on 24/07/2019.
//  Copyright © 2019 Phaedra. All rights reserved.
//

import Foundation

class ControllerconnectionImpl
{
  
    

    var client: ControllerClient
    var client2: ControllerClientFirmware
    static var instance=ControllerconnectionImpl()
    var controller : Controller
    var frontData: [String : String] = [:]
    private let serialQueue = DispatchQueue(label: "SerialQueue")

    
    init()
    {
        self.client=ControllerClient()
        self.client2=ControllerClientFirmware()
        self.controller = Controller(serial: "654321")
    }
    
    static func getInstance() -> ControllerconnectionImpl
    {
        if(ControllerconnectionImpl.instance==nil)
        {
            ControllerconnectionImpl.instance=ControllerconnectionImpl()
            return ControllerconnectionImpl.instance
        }
        else
        {
            return ControllerconnectionImpl.instance
        }
    }
    
    func getController() -> Controller {
        return self.controller
    }
    func setController(controller: Controller) {
        self.controller=controller
    }
    
    
    func reuqestSetWithoutEncrypt(key: String, value: String, reuqestSetWithoutEncryptCompletionHandler: @escaping (_ controlerResponse: ControllerResponseImpl) -> Void)
    {
        requestSet(key: key, value: value, encryptionMode: "-") {
            (ControllerResponseImpl) in
            reuqestSetWithoutEncryptCompletionHandler(ControllerResponseImpl)
        }
//        return requestSet(key: key, value: value, encryptionMode: "-")
    }
    
    func requestSet(key: String, value: String, encryptionMode: String, requestCompletionHandler: @escaping (_ controlerResponse: ControllerResponseImpl) -> Void)
    {
//        serialQueue.async{
//            self.semaphore.wait()
        if(checkDemo())
        {
            do {
                sleep(1)
                let temp = simulateRequest(arg: "nothing")
                requestCompletionHandler(temp)
            }
        }else
        {
            let request : ControllerRequestImpl = ControllerRequestImpl()
                        request.setSetRequest(password: self.controller.getPassword(), key: key, value: value)
                        self.client.sendRequest(senderAddr: Util.getWiFiAddress()!, receiverAddr: self.controller.getIp(), request: request, appId: Util.getAppId(), serial: self.controller.getSerial(), encryptionMode: encryptionMode, apprelay: self.connectedOnAppRelay()) { (ControllerResponseImpl) in
                            requestCompletionHandler(ControllerResponseImpl)
            //                self.semaphore.signal()
                        }
        }

            
//        }
  

//    return true
    }
    let semaphore = DispatchSemaphore(value: 1)

    func requestRead(key: String, completionfinal: @escaping (_ controlerResponse: ControllerResponseImpl) -> Void)
    {
//        serialQueue.async{
            //        var completion : Bool = false
//            self.semaphore.wait()
        if(checkDemo())
        {
            let temp = simulateRequest(arg: key)
            completionfinal(temp)
        }else
        {
                  let request : ControllerRequestImpl = ControllerRequestImpl()
                        request.setReadRequest(password: self.controller.getPassword(), value: key)
                    self.client.sendRequest(
                            senderAddr: Util.getWiFiAddress()!, receiverAddr: self.controller.getIp(), request: request, appId: Util.getAppId(), serial: self.controller.getSerial(), encryptionMode: " ", apprelay: self.connectedOnAppRelay())
                        { (ControllerResponseImpl) in
                            completionfinal(ControllerResponseImpl)
            //                self.semaphore.signal()
                        }
        }
      
//        }
    }
    func requestMinMax(key: String, completionfinal: @escaping (_ controlerResponse: ControllerResponseImpl) -> Void)
    {
        //        serialQueue.sync{
        //        var completion : Bool = false
        if(checkDemo())
        {
        do {
                sleep(1)
                let temp = simulateRequest(arg: "nothing")
                completionfinal(temp)
            }
        }
        else
        {
            let request : ControllerRequestImpl = ControllerRequestImpl()
                   request.setMinMaxRequest(password: self.controller.getPassword(), value: key)
                   self.client.sendRequest(
                       senderAddr: Util.getWiFiAddress()!, receiverAddr: self.controller.getIp(), request: request, appId: Util.getAppId(), serial: self.controller.getSerial(), encryptionMode: " ", apprelay: self.connectedOnAppRelay())
                   { (ControllerResponseImpl) in
                       completionfinal(ControllerResponseImpl)
                   }
        }
       
        //        }
    }
    func readF11(completionF11: @escaping (_ controlerResponse: ControllerResponseImpl) -> Void)
    {
//        serialQueue.sync {
//        self.semaphore.wait()

            let request : ControllerRequestImpl = ControllerRequestImpl()
            request.setF11Request(password: self.controller.getPassword(), value: "*")
        self.client.sendRequest(senderAddr: Util.getWiFiAddress()!, receiverAddr: self.controller.getIp(),
                               request: request,
                               appId: Util.getAppId(),
                               serial: self.controller.getSerial(),
                               encryptionMode: " ",
                               apprelay: self.connectedOnAppRelay())
            { (ControllerResponseImpl) in
                completionF11(ControllerResponseImpl)
//                self.semaphore.signal()
            }
//    }
      
    }
    
    func requestF11Identified(controllerResponsef11: @escaping (_ controllerResponseF11: ControllerResponseImpl) -> Void)
    {
        if(checkDemo())
        {
            let temp = simulateRequest(arg: "*")
            
            self.setFrontData(frontdata: temp.getF11Values())
            controllerResponsef11(temp)
            
        }else
        {
              readF11 {
                        (ControllerResponseImpl) in
                        if(ControllerResponseImpl.getPayload().contains("nothing"))
                        {
            //                print("f11 got no response")
                            controllerResponsef11(ControllerResponseImpl)
                            //                self.showToast(message: "TimeOut Error Try Again")
                        }
                        else
                        {
                            self.setFrontData(frontdata: ControllerResponseImpl.getF11Values())
                            controllerResponsef11(ControllerResponseImpl)
                            
                        }
                    }
        }
    }
    
    func requestDiscovery(controllerResponse: @escaping (_ responseGot: ControllerResponseImpl) -> Void)
    {
//        serialQueue.async {
//        self.semaphore.wait()

        if(checkDemo())
        {
            let temp = simulateRequest(arg: "discovery")
            controllerResponse(temp)
        }
        else
        {
               let request : ControllerRequestImpl = ControllerRequestImpl()
                        request.setDiscoveryRequest(password: self.controller.getPassword())
                    self.client.sendRequest(senderAddr: Util.getWiFiAddress()!, receiverAddr: self.controller.getIp(),
                                       request: request, appId: Util.getAppId(),
                                       serial: self.controller.getSerial(), encryptionMode: " ",
                                       apprelay: self.connectedOnAppRelay())
                    {
                        (ControllerResponseImpl) in
                        controllerResponse(ControllerResponseImpl)
            //            self.semaphore.signal()

                    }
        }
     
//        }

    }
    func requestSetFirmwareUpdate(key: String, value: [UInt8], encryptionMode: String, requestCompletionHandler: @escaping (_ controlerResponse: ControllerResponseImpl) -> Void)
    {
        let request : ControllerRequestImpl = ControllerRequestImpl()
//
        request.setSetFirmWareRequest(password: controller.getPassword(), key: key, value: value)
        client2.sendRequestFirmwareIO(senderAddr: Util.getWiFiAddress()!, receiverAddr: controller.getIp(), request: request, appId: Util.getAppId(), serial: controller.getSerial(), encryptionMode: encryptionMode, apprelay: connectedOnAppRelay()) { (ControllerResponseImpl) in
            requestCompletionHandler(ControllerResponseImpl)
        }
        
        //    return true
    }
    
    func connectedOnAppRelay() -> Bool {
        return controller.getIp().contains("apprelay")
    }
    
    func setFrontData(frontdata:[String: String])
    {
        self.frontData=frontdata
    }
    func getFrontData() -> [String :String] {
        return self.frontData
    }
    
    
    func checkDemo() -> Bool {
        if(controller.getSerial() == "12345")
        {
            return true
        }else
        {
            return false
        }
    }
    func simulateRequest(arg:String) -> ControllerResponseImpl {
        var tempResponse = ControllerResponseImpl()
        if(arg == "*")
        {
            tempResponse.setfunctionID(id: "11")
            tempResponse.setstatusCode(code: "0")
            tempResponse.setpayload(payload:"24.7,29.0,0,249.5,0.0,0,5,0,0,0.0,0.0,0,0,0,0,0,1,0.0,0.0,0.0,0.0,0.0,999,0.00,35.0,20.00,22.2,0.0,100,0.00,0.00,0.0,100.1,0,0.00,15.2,0,180,99,0,0.0,0.0,0.0,0.0,,0.00,0,0,0.0,0,0,0.0,0,0.00,0.0,0.0,1,2.5,7,260,10,0,0,0.10,2.5,0,0,260,bilawal-5g,5,2,9,11,0,1,30,50,0,0,0,0,0,0,0,0,7,38,50,60,0,0,0.0,0,100/0,01/12-20 10:04:46,0,0,0,0,100,0,800,900,0,0,0,0.0,6,0,0,800.0,0,0,0,0,0,20,80,1,0,0,0,894859,0,0,-99.7,1")
        }else if (arg == "discovery")
        {
            tempResponse.setpayload(payload: "Serial=12345;IP=192.168.100.3;Type=v13std;Ver=705;Build=30;Lang=0")
        }else if (arg == "boiler.monday_24")
        {
            tempResponse.setpayload(payload: "monday_24=000000000000220101000000")
        }else if (arg == "boiler.tuesday_24")
        {
            tempResponse.setpayload(payload: "tuesday_24=000000000000031100100000")
        }else if (arg == "boiler.wednesday_24")
        {
            tempResponse.setpayload(payload: "wednesday_24=000000000000312000200000")
        }else if (arg == "boiler.thursday_24")
        {
            tempResponse.setpayload(payload: "thursday_24=000000000000001000100000")
        }else if (arg == "boiler.friday_24")
        {
            tempResponse.setpayload(payload: "friday_24=000000000000000000000000")
        }else if (arg == "boiler.saturday_24")
        {
            tempResponse.setpayload(payload: "saturday_24=000000000000000000000000")
        }else if (arg == "boiler.sunday_24")
        {
            tempResponse.setpayload(payload: "sunday_24=000000000000000000000000")
        }else if(arg == "fan.*")
        {
            tempResponse.setpayload(payload: "output_exhaust=8;speed_10=40;speed_50=20;speed_100=80;use_fan_rpm=0;alarm_fan_rpm=0;alarm_fan_current=0;exhaust_10=38;exhaust_50=50;exhaust_100=60")
        }else if (arg == "auger.*")
        {
            tempResponse.setpayload(payload: "forced_run=0;auger_capacity=260;auto_calculation=0;auger_10=20.00;auger_50=25.0;auger_100=35.0;kw_min=2.5;kw_max=7;runs_minute=3;min_dose=5.0")
        }else if (arg == "wifi.router")
        {
            tempResponse.setpayload(payload: "router=bilawal-5g,2,0,1,192.168.100.3,192.168.100.1,-47,0,0,68:c6:3a:dd:b2:e9")
        }else if (arg == "ignition.*")
        {
            tempResponse.setpayload(payload: "pellets=90.0;power=75;fan_10=100;fan_50=100;fan_100=100;max_time=12;preheat_time=30;exhaust_speed=50;ignition_number=0;clear_ignitions=0")
        }else if (arg == "auger.*")
        {
            tempResponse.setpayload(payload: "forced_run=0;auger_capacity=260;auto_calculation=0;auger_10=20.00;auger_50=25.0;auger_100=35.0;kw_min=2.5;kw_max=7;runs_minute=3;min_dose=5.0")
        }else if (arg == "cleaning.*")
        {
            tempResponse.setpayload(payload: "output_ash=7;output_burner=6;output_boiler1=9;output_boiler2=10;fan_period=6;fan_time=8;fan_speed=100;comp_period=800;valve_period=900;valve_time=110;pellets_stop=160;comp_fan_speed=190;pressure_t7=0;trip_countdown=0;trip_setpoint=0;monday=;tuesday=;wednesday=;thursday=;friday=;saturday=;sunday=;allweek=;ashbox_active=0;ashbox_reset_alarm=0")
        }else if(arg == "boiler.*")
        {
            tempResponse.setpayload(payload: "temp=29;diff_over=1;diff_under=1;reduction=0;ext_stop_temp=0.0;ext_stop_diff=1.0;ext_switch=0;ext_off_delay=1;ext_on_delay=1;timer=0;monday=000000000000;tuesday=000000000000;wednesday=000000000000;thursday=000000000000;friday=000000000000;saturday=000000000000;sunday=000000000000;monday_24=;tuesday_24=;wednesday_24=;thursday_24=;friday_24=;saturday_24=;sunday_24=;min_return=280")
            
        }else if(arg == "fan.*")
        {
            tempResponse.setpayload(payload: "output_exhaust=8;speed_10=40;speed_50=20;speed_100=80;use_fan_rpm=0;alarm_fan_rpm=0;alarm_fan_current=0;exhaust_10=38;exhaust_50=50;exhaust_100=60")
        }else if (arg == "nothing")
        {
            tempResponse.setpayload(payload: "nothing")
        }
        return tempResponse
    }
    
}
