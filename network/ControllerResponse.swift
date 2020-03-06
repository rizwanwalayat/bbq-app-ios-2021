//
//  ControllerResponse.swift
//  BBQ
//
//  Created by Macbook Pro on 24/07/2019.
//  Copyright © 2019 Phaedra. All rights reserved.
//

import Foundation

protocol ControllerResponse
{
    func setData(response: Data)
    func GetReadValue() -> Dictionary<String,String>
}
