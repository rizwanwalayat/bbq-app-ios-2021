//
//  IWatchDogDelegate.swift
//  Aduro
//
//  Created by Macbook Pro on 01/04/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import Foundation

protocol IWatchDogDelegate {
    func onLost()
    func onAvailable()
}
