//
//  Language.swift
//  Aduro
//
//  Created by Macbook Pro on 25/02/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import Foundation
import SwiftyJSON

class Language {
    static var instance=Language()
    var jsondata:JSON!
    let defaults = UserDefaults.standard

    init() {
        let language=defaults.string(forKey: Constants.languageKey)
        if(language==nil)
        {
            readjson(fileName: "en")
        }else
        {
            readjson(fileName: language!)
        }
        
    }
    
    static func getInstance() -> Language
    {
        if(Language.instance==nil)
        {
            Language.instance=Language()
            return Language.instance
        }
        else
        {
            return Language.instance
        }
    }
    
    func getlangauge(key:String) -> String {
        return jsondata[key].rawString()!
    }
    
    func readjson(fileName: String) {
        
        let langauge=fileName+".json"
        let path = Bundle.main.path(forResource: langauge, ofType: nil)
        //        let jsonData = NSData(contentsOfMappedFile: path!)
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
            let jsonObj = try JSON(data: data)
            jsondata=jsonObj
//            print("jsonData:\(jsonObj)")
        } catch let error {
            print("parse error: \(error.localizedDescription)")
        }
        //        return jsonData!
    }
    
}
