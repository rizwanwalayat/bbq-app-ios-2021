//
//  WizardMainViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 24/02/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit
import CoreLocation
import FGRoute


class WizardMainViewController: UIViewController,CLLocationManagerDelegate  {

    var locationManager:CLLocationManager!
    let defaults = UserDefaults.standard
    var fromHomeScreen: Bool = false
    
    @IBOutlet weak var gradient: gradient!
    @IBOutlet weak var startbtn: RoundButton!
    @IBOutlet weak var wizard_1_title: UILabel!
    @IBOutlet weak var wizard_1_description: UILabel!
    @IBOutlet weak var wizard_1_description2: UILabel!
    @IBOutlet weak var wizard_1_description3: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.gradient.installGradientwithvounds(frame: self.view.bounds)

        self.gradient.updateGradient(frame: self.view.bounds)
        wizard_1_title.text=Language.getInstance().getlangauge(key: "wizard_1_title")
        wizard_1_description.text="A.  "+Language.getInstance().getlangauge(key: "wizard_1_description")
        wizard_1_description2.text="B.  "+Language.getInstance().getlangauge(key: "wizard_1_description2")
        wizard_1_description3.text="C.  "+Language.getInstance().getlangauge(key: "wizard_1_description3")
        startbtn.setTitle(Language.getInstance().getlangauge(key: "wizard_1_button"), for: .normal)
        
        locationManager=CLLocationManager()
        locationManager.delegate=self
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        Checklocation()
    }
    func Checklocation() {
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                locationManager.requestWhenInUseAuthorization()
                break
            case .authorizedAlways, .authorizedWhenInUse:
                let ssid = FGRoute.getSSID()
                self.triggerLocalNetworkPrivacyAlert()
                
                //                print("Access")
//                checkConnectionType()
                break
            }
        }
        else
        {
            print("not enable")
        }
    }
    
    func triggerLocalNetworkPrivacyAlert() {
            let sock4 = socket(AF_INET, SOCK_DGRAM, 0)
            guard sock4 >= 0 else { return }
            defer { close(sock4) }
            let sock6 = socket(AF_INET6, SOCK_DGRAM, 0)
            guard sock6 >= 0 else { return }
            defer { close(sock6) }
            
            let addresses = addressesOfDiscardServiceOnBroadcastCapableInterfaces()
            var message = [UInt8]("!".utf8)
            for address in addresses {
                address.withUnsafeBytes { buf in
                    let sa = buf.baseAddress!.assumingMemoryBound(to: sockaddr.self)
                    let saLen = socklen_t(buf.count)
                    let sock = sa.pointee.sa_family == AF_INET ? sock4 : sock6
                    _ = sendto(sock, &message, message.count, MSG_DONTWAIT, sa, saLen)
                }
            }
        }
        private func addressesOfDiscardServiceOnBroadcastCapableInterfaces() -> [Data] {
            var addrList: UnsafeMutablePointer<ifaddrs>? = nil
            let err = getifaddrs(&addrList)
            guard err == 0, let start = addrList else { return [] }
            defer { freeifaddrs(start) }
            return sequence(first: start, next: { $0.pointee.ifa_next })
                .compactMap { i -> Data? in
                    guard
                        (i.pointee.ifa_flags & UInt32(bitPattern: IFF_BROADCAST)) != 0,
                        let sa = i.pointee.ifa_addr
                    else { return nil }
                    var result = Data(UnsafeRawBufferPointer(start: sa, count: Int(sa.pointee.sa_len)))
                    switch CInt(sa.pointee.sa_family) {
                    case AF_INET:
                        result.withUnsafeMutableBytes { buf in
                            let sin = buf.baseAddress!.assumingMemoryBound(to: sockaddr_in.self)
                            sin.pointee.sin_port = UInt16(9).bigEndian
                        }
                    case AF_INET6:
                        result.withUnsafeMutableBytes { buf in
                            let sin6 = buf.baseAddress!.assumingMemoryBound(to: sockaddr_in6.self)
                            sin6.pointee.sin6_port = UInt16(9).bigEndian
                        }
                    default:
                        return nil
                    }
                    return result
                }
        }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            let ssid = FGRoute.getSSID()
            self.triggerLocalNetworkPrivacyAlert()
            manager.startUpdatingLocation()
            //            checkConnectionType()
            //            print(FGRoute.getSSID()!)
            
            break
        case .authorizedAlways:
            // If always authorized
            //            manager.startUpdatingLocation()
            //            print(FGRoute.getSSID())
            //            checkConnectionType()
            
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            manager.requestWhenInUseAuthorization()
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    
    @IBAction func startBtnPressed(_ sender: Any) {
        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return}
        sVC.modalPresentationStyle = .fullScreen
        self.present(sVC, animated: false)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        let serial=defaults.string(forKey: Constants.serialKey)
//        let password=defaults.string(forKey: Constants.passwordKey)
//        if(serial != nil)
//        {
//            loadmain(serial: serial!, password: password!)
//        }
//    }
//    func loadmain(serial:String,password:String)  {
//        guard  let sVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return}
//        sVC.serial=serial
//        sVC.password=password
//        sVC.fromSplash=true
//        self.present(sVC, animated: true)
//    }
    
}
