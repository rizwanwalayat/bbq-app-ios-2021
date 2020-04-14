//
//  Util.swift
//  BBQ
//
//  Created by Macbook Pro on 25/07/2019.
//  Copyright © 2019 Phaedra. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import FGRoute
class Util
{
    
    static var appid : String = ""
    static var majorVersion:Int = 2
    static var minorVersion:Int = 28
    
    static func getWiFiAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
                    
                    let name: String = String(cString: (interface!.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? ""
    }
    
   static func GetSSID() -> String {
    let ssid=FGRoute.getSSID() ?? ""
        return ssid
    }
    
    static func GetDefaultsString(key:String) -> String
    {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: key) ?? "nothing"
    }
    
    static func SetDefaults(key:String,value:String)  {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    static func GetDefaultsBool(key:String) -> Bool
    {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: key)
    }
    
    static func SetDefaultsBool(key:String,value:Bool)  {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
//    static func getWiFiAddress() -> String? {
//        var address : String?
//
//        // Get list of all interfaces on the local machine:
//        var ifaddr : UnsafeMutablePointer<ifaddrs>?
//        guard getifaddrs(&ifaddr) == 0 else { return nil }
//        guard let firstAddr = ifaddr else { return nil }
//
//        // For each interface ...
//        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
//            let interface = ifptr.pointee
//
//            // Check for IPv4 or IPv6 interface:
//            let addrFamily = interface.ifa_addr.pointee.sa_family
//            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
//
//                // Check interface name:
//                let name = String(cString: interface.ifa_name)
//                if  name == "en0" {
//
//                    // Convert interface address to a human readable string:
//                    var addr = interface.ifa_addr.pointee
//                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
//                                &hostname, socklen_t(hostname.count),
//                                nil, socklen_t(0), NI_NUMERICHOST)
//                    address = String(cString: hostname)
//                }
//            }
//        }
//        freeifaddrs(ifaddr)
//
//        return address ?? ""
//    }
    static func getWiFiSsid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
    
   static func fetchSSIDInfo() -> Any? {
        // see http://stackoverflow.com/a/5198968/907720
        let ifs = CNCopySupportedInterfaces() as? [AnyHashable]
        if let ifs = ifs {
            print("Supported interfaces: \(ifs)")
        }
        var info: [AnyHashable : Any]?
        for ifnam in ifs ?? [] {
            guard let ifnam = ifnam as? String else {
                continue
            }
            info = CNCopyCurrentNetworkInfo(ifnam as CFString) as? [AnyHashable : Any]
            if let info = info {
                print("\(ifnam) => \(info)")
            }
            if info != nil && info?.count != nil {
                break
            }
        }
        return info
    }
//    func getConnectedSSID() -> String{
//        let r = fetchSSIDInfo()
//
//        var ssid: String? = nil
//        if let kCNNetworkInfoKeySSID = kCNNetworkInfoKeySSID as? AnyHashable {
//            ssid = r![kCNNetworkInfoKeySSID] as? String
//        } //@"SSID"
//
//        if ssid != nil && (ssid?.count ?? 0) != 0 {
//            return ssid!
//        } else {
//            return "not available"
//        }
//
//    }
   static func getConnectedWifiInfo() -> [AnyHashable: Any]? {
        
        if let ifs = CFBridgingRetain( CNCopySupportedInterfaces()) as? [String],
            let ifName = ifs.first as CFString?,
            let info = CFBridgingRetain( CNCopyCurrentNetworkInfo((ifName))) as? [AnyHashable: Any] {
            
            return info
        }
        return nil
        
    }
    

   static func getHostIpAddress(hostDomainNama:CFString) -> String?{
        let host = CFHostCreateWithName(nil,hostDomainNama as CFString).takeRetainedValue()
        CFHostStartInfoResolution(host, .addresses, nil)
        var success: DarwinBoolean = false
        if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray?,
            let theAddress = addresses.firstObject as? NSData {
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            if getnameinfo(theAddress.bytes.assumingMemoryBound(to: sockaddr.self), socklen_t(theAddress.length),
                           &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                let numAddress = String(cString: hostname)
                //print(numAddress)
                return numAddress
            }
        }
        return nil
    }
    static func getAppId() -> String {
        
        if Util.appid==""
        {
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            Util.appid=String((0..<12).map{ _ in letters.randomElement()! })
            return Util.appid
        }
        else
        {
            return Util.appid
        }
        
    }
    
    static func showDialog(view: UIViewController)
    {
      
    }
    
}
