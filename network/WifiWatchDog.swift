//
//  WifiWatchDog.swift
//  Aduro
//
//  Created by Macbook Pro on 01/04/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import Foundation
import Network

class WifiWatchDog {
    static var  intance: WifiWatchDog!
    var monitor:NWPathMonitor!

    init() {
    }
   static  func getInstance() -> WifiWatchDog {
        if(intance==nil)
        {
            intance=WifiWatchDog()
        }
        return intance
    }
    
    func registernetwork( delegate:IWatchDogDelegate)  {
        monitor = NWPathMonitor(requiredInterfaceType: .wifi)
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status == .satisfied {
//                print("Internet connection is on.")
                delegate.onAvailable()
            } else {
//                print("There's no internet connection.")
                delegate.onLost()
            }
        }
        monitor.start(queue: queue)
    }
    func unRegisterMonitor()  {
        monitor.cancel()
    }
    
    
}
