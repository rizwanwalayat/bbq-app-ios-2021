//
//  WizardMainViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 24/02/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit
import CoreLocation

class WizardMainViewController: UIViewController,CLLocationManagerDelegate  {

    var locationManager:CLLocationManager!
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var wizard_1_title: UILabel!
    @IBOutlet weak var wizard_1_description: UILabel!
    @IBOutlet weak var wizard_1_description2: UILabel!
    @IBOutlet weak var wizard_1_description3: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        wizard_1_title.text=Language.getInstance().getlangauge(key: "wizard_1_title")
        wizard_1_description.text="A.  "+Language.getInstance().getlangauge(key: "wizard_1_description")
        wizard_1_description2.text="B.  "+Language.getInstance().getlangauge(key: "wizard_1_description2")
        wizard_1_description3.text="C.  "+Language.getInstance().getlangauge(key: "wizard_1_description3")
        
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
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
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
