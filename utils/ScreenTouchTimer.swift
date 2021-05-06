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
     var timeoutInSeconds: TimeInterval = Double(Util.GetDefaultsString(key: general.screen_lock_time) == "nothing" ? "10" : Util.GetDefaultsString(key: general.screen_lock_time))!
 

var idleTimer: Timer?

    
    override init() {
        super.init()
        idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds+5, target: self, selector: #selector(self.idleTimerExceeded), userInfo: nil, repeats: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(resetIdleTimer), name: Notification.Name.TimeOutValueChanged, object: nil)
    }
    
// Listen for any touch. If the screen receives a touch, the timer is reset.
override func sendEvent(_ event: UIEvent) {
    super.sendEvent(event)

    if idleTimer != nil {
        self.resetIdleTimer()
    }

    if let touches = event.allTouches {
        for touch in touches {
            if touch.phase == UITouch.Phase.began {
                self.resetIdleTimer()
            }
        }
    }
}


// Reset the timer because there was user interaction.
    @objc func resetIdleTimer() {
    if let idleTimer = idleTimer {
        idleTimer.invalidate()
        timeoutInSeconds = Double(Util.GetDefaultsString(key: general.screen_lock_time) == "nothing" ? "10" : Util.GetDefaultsString(key: general.screen_lock_time))!
    }
    
    idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds, target: self, selector: #selector(self.idleTimerExceeded), userInfo: nil, repeats: false)
}

// If the timer reaches the limit as defined in timeoutInSeconds, post this notification.
    @objc func idleTimerExceeded() {
    NotificationCenter.default.post(name:Notification.Name.TimeOutUserInteraction, object: nil)
   }
}
