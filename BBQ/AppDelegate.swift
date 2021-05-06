//
//  AppDelegate.swift
//  Aduro
//
//  Created by Macbook Pro on 21/02/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit
import Network
import Sentry
import FGRoute
import SQLite
import SQLite3
import UserNotifications


//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var monitor:NWPathMonitor!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Language.getInstance()
        application.setMinimumBackgroundFetchInterval(5)
        // Override point for customization after application launch.
        SentrySDK.start { options in
               options.dsn = "https://c8a4d2191f59429984b562b1bb7bac11@o399454.ingest.sentry.io/5450800"
               options.debug = true // Enabled debug when first installing is always helpful
           }
     
//        registernetwork()
        registernetwork()
//        var config = Realm.Configuration()
//
//          // Use the default directory, but replace the filename with the username
//          config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\("aduro").realm")
//        config.schemaVersion = 8
//
//          // Set this as the configuration used for the default Realm
//          Realm.Configuration.defaultConfiguration = config
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        do {
            let db = try Connection("\(path)/db.sqlite3")
            if db.userVersion == 0 {
                // handle first migration
                db.userVersion = 1
            }
            db.trace { print($0) }
//            let temp =
//                try db.execute("SELECT * FROM sqlite_master WHERE type='table' name='users'")
            let notification = Table("notification")

            let id = Expression<Int64>("id")
            let epoch = Expression<String>("epoch")
            let serial = Expression<String?>("serial")
            let isRead = Expression<Bool>("isRead")
            let isReadFromApp = Expression<Bool>("isReadFromApp")
            let message = Expression<String>("message")
//            try db.run(users.create(QueryType))
            let string = notification.create(ifNotExists : true) {  t in// CREATE TABLE "users" (
                t.column(id, primaryKey: .autoincrement) //     "id" INTEGER PRIMARY KEY NOT NULL,
                t.column(serial, unique: false)  //     "email" TEXT UNIQUE NOT NULL,
                t.column(isRead,defaultValue: false)
                t.column(epoch,defaultValue: "123456789")
                t.column(message,defaultValue: "")
                t.column(isReadFromApp,defaultValue: false)//     "name" TEXT
            }
        
//            try db.run(notification.drop(ifExists: true))
            try db.run(string)
//            let rowid = try db.run(notification.insert(serial <- "alice@mac.com"))
// )
            } catch let myError {
                print("error")
            }
      
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }

        notificationCenter.delegate = self

        return true
    }


    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("bacground called")
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func checkForReachability()  {
        print("")
    }
        func registernetwork()  {
            monitor = NWPathMonitor()
            let queue = DispatchQueue(label: "InternetConnectionMonitor")
            monitor.pathUpdateHandler = { pathUpdateHandler in
                if pathUpdateHandler.status == .satisfied {
    //                print("Internet connection is on.")
//                    delegate.onAvailable()
                    if(FGRoute.isWifiConnected())
                    {
//                        wifi case
                        let ssid=FGRoute.getSSID()
                        if let ssidvalue = ssid
                        {
//                            onsame wifi
                           if(ssidvalue.starts(with: "RTB-") || ssidvalue.starts(with: "BBQ-"))
                           {
                            if (ControllerconnectionImpl.getInstance().getController().getIp() != "")
                            {
                                ControllerconnectionImpl.getInstance().getController().swapToLocal()
                            }
                            }else
                           {
                            if (ControllerconnectionImpl.getInstance().getController().getIp() != "")
                                                       {
                                ControllerconnectionImpl.getInstance().getController().swapToAppRelay()
                            }
                            }
                        }
                    }else
                    {
//                        4g case
                        ControllerconnectionImpl.getInstance().getController().swapToAppRelay()
                    }
//                    print("connected change")
                } else {
    //                print("There's no internet connection.")
//                    delegate.onLost()
//                    print("network  lost")
                }
            }
            monitor.start(queue: queue)
        }

}


extension Connection {
    public var userVersion: Int32 {
        get { return Int32(try! scalar("PRAGMA user_version") as! Int64)}
        set { try! run("PRAGMA user_version = \(newValue)") }
    }
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])

    }
}
