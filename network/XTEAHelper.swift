//
//  XTEAHelper.swift
//  Nu
//
//  Created by Pawan Jat on 14/02/17.
//
//

import Foundation

class XTEAHelper {
    
    //MARK:- Veriable declaration
    let TAG = "XTEAHelper"
    public let XTEA_SETUP_VALUE = "misc.xtea_key"
    public  static var key:[UInt8]? = nil
    
    init() {
        
    }
    //MARK:- Methods
    public func getKey() -> String{
        if(XTEAHelper.key == nil){
            return ""
        }else{
            return String(describing: XTEAHelper.key)
        }
    }
    
    public func loadKey() -> String{
        let keyString:String = randomString(length: 16)//"vokjHa5Xqr80zlxm"
        let bytes = keyString.utf8
        var byteArray = [UInt8]()
        for char in keyString.utf8{
            let byte = UInt8(char)
            byteArray.append(byte)
        }
        XTEAHelper.key = byteArray
        return keyString
    }

    
    public func encrypt(bs:inout [Int8]) -> [Int8]{
        let xtea = XTEA()
        if(XTEAHelper.key != nil){
            xtea.setKey(b: XTEAHelper.key!)
        }
        xtea.encrypt(bytes: &bs, off: 0, length: bs.count)
        return bs
    }
    
    public func decrypt(bs:inout [Int8]) -> [Int8]{
        let xtea = XTEA()
        xtea.setKey(b: XTEAHelper.key!)
        xtea.decrypt(bytes: &bs, off: 0, length: bs.count)
        return bs
    }
    
    
    public func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
}
