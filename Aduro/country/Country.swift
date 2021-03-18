//
//  Country.swift
//  CleaningPal
//
//  Created by Mac on 11/05/2020.
//  Copyright © 2020 Mian Faizan Nasir. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

typealias CountryCompletionHandler = (_ data: [Country]) -> Void

class Country: Mappable {
    
    var name = "Pakistan"
    var code = "PK"
    var dial_code = "+92"
    var image = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name        <- map["name"]
        code        <- map["code"]
        dial_code   <- map["dial_code"]
        image       <- map["image"]
        
        image = "https://www.countryflags.io/\(code)/flat/64.png"
    }
    
    class func laodData(completion: @escaping CountryCompletionHandler) {
//        Utility.showLoading()
        
        if let path = Bundle.main.path(forResource: "Countries", ofType: "json") {
            
            if let jsonData =  try! String(contentsOfFile: path).data(using: .utf8) {
                
                if let jsonResult: NSDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    
                    if let persons : NSArray = jsonResult["countries"] as? NSArray {
                        
                        if let x = Mapper<Country>().mapArray(JSONObject: persons) {
//                            Utility.hideLoading()
                            completion(x)
                            
                        } else  {
//                            Utility.hideLoading()
                        }
                        
                    } else {
//                        Utility.hideLoading()
                    }
                    
                } else {
//                    Utility.hideLoading()
                }
                
            } else {
//                Utility.hideLoading()
            }
            
        } else {
//            Utility.hideLoading()
        }
    }
    
    func getParams() -> [String:String] {
        return ["name": name,
                "code": code,
                "dial_code": dial_code]
    }
}

class Countries: Mappable {
    
    var countries = [Country]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        countries       <- map["countries"]
    }
}
