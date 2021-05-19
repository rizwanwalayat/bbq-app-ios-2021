//
//  ScreenTouchTimer.swift
//  BBQ
//
//  Created by ps on 06/05/2021.
//  Copyright © 2021 nbe. All rights reserved.
//

import Foundation
import UIKit

extension NSNotification.Name {
    public static let TimeOutUserInteraction: NSNotification.Name = NSNotification.Name(rawValue: "TimeOutUserInteraction")
    public static let TimeOutValueChanged: NSNotification.Name = NSNotification.Name(rawValue: "TimeOutValueChanged")
}

class ScreenTouchTimer: UIApplication {
    
    // The timeout in seconds for when to fire the idle timer.
    static var timeoutInSeconds: TimeInterval = Double(Util.GetDefaultsString(key: general.screen_lock_time) == "nothing" ? "10" : Util.GetDefaultsString(key: general.screen_lock_time))!
    
    
    static var idleTimer: Timer?
    
    
    override init() {
        super.init()
//        ScreenTouchTimer.idleTimer = Timer.scheduledTimer(timeInterval: ScreenTouchTimer.timeoutInSeconds+5, target: self, selector: #selector(self.idleTimerExceeded), userInfo: nil, repeats: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(resetIdleTimer), name: Notification.Name.TimeOutValueChanged, object: nil)
    }
    
    // Listen for any touch. If the screen receives a touch, the timer is reset.
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
//        if ScreenTouchTimer.idleTimer != nil {
//            self.resetIdleTimer()
//        }
        
        if let vc =
            UIApplication.shared.keyWindow?.rootViewController?.topMostViewController() as? HomeViewController {
            if let touches = event.allTouches {
                for touch in touches {
                    if touch.phase == UITouch.Phase.began {
                        self.resetIdleTimer()
                    }
                }
            }
        }
        
//        else {
//            ScreenTouchTimer.stopIdleTimer()
//        }
    }
    
    class func startIdleTimer(){
        if let idleTimer = ScreenTouchTimer.idleTimer {
            idleTimer.invalidate()
        }
//        ScreenTouchTimer.idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds+5, target: self, selector: #selector(idleTimerExceeded), userInfo: nil, repeats: false)
        ScreenTouchTimer.idleTimer = Timer.scheduledTimer(withTimeInterval: timeoutInSeconds+5, repeats: false, block: { (Timer) in
            Timer.invalidate()
            NotificationCenter.default.post(name:Notification.Name.TimeOutUserInteraction, object: nil)

        })
        
    }
    
    class func stopIdleTimer(){
        if let idleTimer = ScreenTouchTimer.idleTimer {
            idleTimer.invalidate()
        }
    }
    // Reset the timer because there was some user interaction.
    @objc func resetIdleTimer() {
        if let idleTimer = ScreenTouchTimer.idleTimer {
            idleTimer.invalidate()
            ScreenTouchTimer.timeoutInSeconds = Double(Util.GetDefaultsString(key: general.screen_lock_time) == "nothing" ? "10" : Util.GetDefaultsString(key: general.screen_lock_time))!
        }
//        ScreenTouchTimer.idleTimer = Timer.scheduledTimer(timeInterval: ScreenTouchTimer.timeoutInSeconds, target: self, selector: #selector(idleTimerExceeded), userInfo: nil, repeats: false)
//        ScreenTouchTimer.startIdleTimer()
        ScreenTouchTimer.idleTimer = Timer.scheduledTimer(withTimeInterval: ScreenTouchTimer.timeoutInSeconds, repeats: false, block: { (Timer) in
            Timer.invalidate()
            NotificationCenter.default.post(name:Notification.Name.TimeOutUserInteraction, object: nil)

        })
        
    }
    
    // If the timer reaches the limit as defined in timeoutInSeconds, post this notification.
    @objc func idleTimerExceeded() {
        NotificationCenter.default.post(name:Notification.Name.TimeOutUserInteraction, object: nil)
    }
    
    
}
