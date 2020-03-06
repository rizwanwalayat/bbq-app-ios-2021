//
//  ControllerConnection.swift
//  BBQ
//
//  Created by Macbook Pro on 24/07/2019.
//  Copyright © 2019 Phaedra. All rights reserved.
//

import Foundation

protocol ControllerConnection {
    
    func reuqestSet(key: String,value: String) -> Bool
    func requestSet(key: String,value: String,encryptionMode: String) -> Bool
    func requestRead(key: String) -> Dictionary<String,String>
//    func requestRead(key: String)
}
