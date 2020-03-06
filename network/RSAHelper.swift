//
//  RSAHelper.swift
//  BBQ
//
//  Created by Macbook Pro on 24/07/2019.
//  Copyright © 2019 Phaedra. All rights reserved.
//

import Foundation


class RSAHelper {
    
    //MARK:- Veriable declaration
    private static var pubKey:PublicKey?
    
    init() {
        
    }
    //MARK:- Methods
    public func getPubKey() -> PublicKey? {
        return RSAHelper.pubKey ?? nil
    }
    
    func loadPubKey(key:String) {
        let decodedData:Data = Base64.decode(key)
        do{
            let convertedPublicKey = try PublicKey(data: decodedData)
            RSAHelper.pubKey = convertedPublicKey
        } catch let error as NSError{
            print(error)
        }
    }
    
    public func encrypt(bs:[Int8]) -> [Int8]?{
        do{
            let inputData:NSData? = NSData(bytes: bs, length: bs.count)
            let inputStr = String(data: inputData as! Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            let clear = try ClearMessage(string: inputStr, using: .utf8)
            let encrypted = try clear.encrypted(with: RSAHelper.pubKey!, padding: SecPadding(rawValue: 0))
            // Then you can use:
            let data = encrypted.data
            return data.toArray(type: Int8.self)
        }catch{
            
        }
        return nil
    }
}
