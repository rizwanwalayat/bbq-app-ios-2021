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
    var term:String!
    var defaultlange:JSON!
    var form : String!
    var wifiterm:String!
    let defaults = UserDefaults.standard

    init() {
        readDefault()
        let language=defaults.string(forKey: Constants.languageKey)
        if(language==nil)
        {
            readjson(fileName: "en")
            ReadTerm(fileName: "en")
            ReadTerm2(fileName: "en")
            readForm(filename: "en")
        }else
        {
            readjson(fileName: language!)
            ReadTerm(fileName: language!)
            ReadTerm2(fileName: language!)
            readForm(filename: language!)
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
        return jsondata[key].rawString() ?? defaultlange[key].rawString() ?? key
    }
    func readForm(filename: String)  {
            
      let langauge="aduro_personal_"+filename+".htm"
                    let path = Bundle.main.path(forResource: langauge, ofType: nil)
                    if(path==nil)
                    {
                       readForm(filename: "en")
                    }else
                    {
                        form = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
                    }
    }
    func readjson(fileName: String) {
        
        
        let langauge=fileName+".json"
//        let langauge="ru.json"
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
    
       func readDefault() {
            
            
            let langauge="en"+".json"
    //        let langauge="ru.json"
            let path = Bundle.main.path(forResource: langauge, ofType: nil)
            //        let jsonData = NSData(contentsOfMappedFile: path!)
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                defaultlange=jsonObj
    //            print("jsonData:\(jsonObj)")
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
            //        return jsonData!
        }
    func ReadTerm(fileName:String)  {
        
        let langauge="aduro_terms_"+fileName+".htm"
        let path = Bundle.main.path(forResource: langauge, ofType: nil)
        if(path==nil)
        {
            ReadTerm(fileName: "en")
        }else
        {
            term = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        }
        
    }
    func ReadTerm2(fileName:String)  {
        
        let langauge="aduro_terms_"+fileName+"_wifi"+".htm"
        let path = Bundle.main.path(forResource: langauge, ofType: nil)
        if(path==nil)
        {
            ReadTerm2(fileName: "en")
        }else
        {
            wifiterm = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        }
        
    }
    func getFirstTerm() -> String {
        return term
    }
    func GetWifiTerm() -> String {
        return wifiterm
    }
    func GetForm() -> String {
        return form
    }
}
