//
//  ControllerRequest.swift
//  BBQ
//
//  Created by Macbook Pro on 24/07/2019.
//  Copyright © 2019 Phaedra. All rights reserved.
//

import Foundation

protocol ControllerRequest {
    
 
    
    func setSetRequest(password: String,key: String,value: String )
    func setReadRequest(password: String ,value: String );
    func setDiscoveryRequest(password: String );
    func setF11Request(password: String ,value: String );
    func setLocalIp(ip: String )
    func setPort(port: String )
    
//    void setSetRequestRaw(password: String ,name: String , byte[] value)
}
