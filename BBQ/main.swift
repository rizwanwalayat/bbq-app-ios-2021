//
//  main.swift
//  BBQ
//
//  Created by ps on 06/05/2021.
//  Copyright © 2021 nbe. All rights reserved.
//

import Foundation
import UIKit

UIApplicationMain(     CommandLine.argc,     UnsafeMutableRawPointer(CommandLine.unsafeArgv)         .bindMemory(             to: UnsafeMutablePointer<Int8>.self,             capacity: Int(CommandLine.argc)),     NSStringFromClass(ScreenTouchTimer.self), NSStringFromClass(AppDelegate.self) )
