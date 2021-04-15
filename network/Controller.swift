//
//  Controller.swift
//  BBQ
//
//  Created by Macbook Pro on 25/07/2019.
//  Copyright © 2019 Phaedra. All rights reserved.
//

import Foundation


class Controller {
    public static let CONTROLLER_DEFAULT_IP : String = "192.168.4.1"
    public static let SSID_PREFIX = "BBQ-";
    var ip = "";
    private var serial = "";
    private var password = "";
    
    init(serial : String) {
        self.serial=serial
    }
    func getPassword() -> String {
        return password
    }
    func setPassword(password : String) {
        self.password=password
    }
    
    func getIp() -> String {
        return self.ip
    }
    func SetIp(ip: String) {
        self.ip=ip
    }
    func getSerial() -> String {
        return self.serial
    }
    
    func setSerial(serial: String)  {
        self.serial=serial
    }
    func isAccessPoint() -> Bool {
    return self.ip.contains(Controller.CONTROLLER_DEFAULT_IP);
    }
    func swapToLocal()  {
        self.ip = Controller.CONTROLLER_DEFAULT_IP
    }
    func swapToAppRelay() {
//        self.ip =  getAppRelayAddress(serial: self.serial)
        self.ip="apprelay20.stokercloud.dk"
        print(ip)
    }
    func getAppRelayAddress(serial : String) -> String {
        if (serial == nil || serial.elementsEqual(""))
        {
            return "apprelay20.stokercloud.dk";
        }
        var digitString = serial.last
        
        if (digitString == "0")
        {
        digitString = "1";
        }
        if (digitString == "2")
        {
        digitString = "3";
        }
        
        return "apprelay\(digitString ?? "2").stokercloud.dk";
    }
}
