//
//  ControllerRequestImpl.swift
//  BBQ
//
//  Created by Macbook Pro on 24/07/2019.
//  Copyright © 2019 Phaedra. All rights reserved.
//

import Foundation

class ControllerRequestImpl: ControllerRequest
{
    func setLocalIp(ip: String) {
          self.localIp=ip
    }
    
    var functionId : String = ""
    var code: String = ""
    var payload: String = ""
    var payloadfirmware : [UInt8]!
    var sequenceNumber: String = "00"
    var appId: String="1234567891t2"
    var serial: String=""
    var timeString: String="0000000000"
    var encryptionMode: String=" "
    var localIp: String=""
    var port: String=""
    var pad:String="pad "
    
    
    func setFunctionId(functionId:String) {
        self.functionId=functionId
    }
    func getFunctionId() -> String {
        return self.functionId
    }
    
    func setCode(code:String) {
        self.code=code
    }
    func setPayload(payload:String)  {
        self.payload=payload
    }
    func setpayloadfirmware(payload:[UInt8]) {
        self.payloadfirmware=payload
    }
    func getpayloadfirmware() -> [UInt8] {
        return self.payloadfirmware
    }
    
    func setsequenceNumber(sequenceNumber:String) {
        self.sequenceNumber=String(sequenceNumber)
    }
    
    func setSetFirmWareRequest(password: String, key: String, value: [UInt8]) {
        self.setFunctionId(functionId: "02")
        self.setCode(code: password)
//        let temppayload=key+"="+value
        self.setpayloadfirmware(payload: value)
    }
    
    func setSetRequest(password: String, key: String, value: String) {
        self.setFunctionId(functionId: "02")
        self.setCode(code: password)
        let temppayload=key+"="+value
        self.setPayload(payload: temppayload)
    }
    
    func setReadRequest(password: String, value: String) {
        self.setFunctionId(functionId: "01")
        self.setCode(code: password)
        self.setPayload(payload: value)
    }
    
    func setDiscoveryRequest(password: String) {
        self.setFunctionId(functionId: "00")
        self.setCode(code: password)
        self.setPayload(payload: "NBE Discovery")
    }
    
    func setF11Request(password: String, value: String) {
        self.setFunctionId(functionId: "11")
        self.setCode(code: password)
        self.setPayload(payload: value)
    }
    
    func setPort(port: String) {
        self.port=port
    }
    func setSquenceNumber(sequenceNumber: Int) {
        self.sequenceNumber=String(sequenceNumber)
    }
    
    func setAppId(appid: String) {
        if(appid==nil)
        {
            self.appId="1234567891t2"
        }else
        {
            self.appId=appid
        }
    }
    func setEncryption(mode: String ) {
        self.encryptionMode=mode
    }
  
    func setSerial(serial: String) {
        self.serial=serial
    }
    func getRawRequestFirmware() -> Data
    {
        var messagesend=NSMutableData()
        messagesend.append(appId.data(using: String.Encoding.ascii)!)
        messagesend.append(serial.data(using: String.Encoding.ascii)!)
        messagesend.append(encryptionMode.data(using: String.Encoding.ascii)!)
        messagesend.append("\u{02}".data(using: String.Encoding.ascii)!)
        messagesend.append(functionId.data(using: String.Encoding.ascii)!)
        messagesend.append(sequenceNumber.data(using: String.Encoding.ascii)!)
        messagesend.append(code.data(using: String.Encoding.ascii)!)
        messagesend.append(timeString.data(using: String.Encoding.ascii)!)
        messagesend.append(pad.data(using: String.Encoding.ascii)!)
        //        print(payload.count)
        var payloadlength = String(payloadfirmware.count + 18 )
        if(payloadlength.count == 2)
        {
            payloadlength = "0" + payloadlength
            messagesend.append(payloadlength.data(using: String.Encoding.ascii)!)
            
        }else if(payloadlength.count == 3)
        {
            messagesend.append(payloadlength.data(using: String.Encoding.ascii)!)
        }
        else if(payloadlength.count == 1)
        {
            payloadlength = "00" + payloadlength
            messagesend.append(payloadlength.data(using: String.Encoding.ascii)!)
        }
        messagesend.append("misc.push_version=".data(using: String.Encoding.ascii)!)
        messagesend.append(payloadfirmware, length: payloadfirmware.count)
        messagesend.append("\u{04}".data(using: String.Encoding.ascii)!)
        messagesend.append(":\(localIp):\(port)".data(using: String.Encoding.ascii)!)
        messagesend.append("\u{04}".data(using: String.Encoding.ascii)!)
        let length = messagesend.count
            return messagesend as Data
    }
    func getRawRequest() -> Data {
        
        var messagesend : String=""
        messagesend.append("")
        messagesend.append(appId)
        messagesend.append(serial)
        messagesend.append(encryptionMode)
        messagesend.append("\u{02}")
        messagesend.append(functionId)
        messagesend.append(sequenceNumber)
        messagesend.append(code)
        messagesend.append(timeString)
        messagesend.append(pad)
//        print(payload.count)
        var payloadlength = String(payload.count)
        if(payloadlength.count == 2)
        {
            payloadlength = "0" + payloadlength
            messagesend.append(payloadlength)
            
        }else if(payloadlength.count == 3)
        {
            messagesend.append(payloadlength)
        }
        else if(payloadlength.count == 1)
        {
            payloadlength = "00" + payloadlength
            messagesend.append(payloadlength)
        }

        messagesend.append(payload)
        messagesend.append("\u{04}")
        messagesend.append(":\(localIp):\(port)")
        messagesend.append("\u{04}")
//
//        print(appId.count)
//        print(serial.count)
//        print(encryptionMode.count)
//        print(functionId.count)
//        print(sequenceNumber.count)
//        print(code.count)
//        print(timeString.count)
//        print(payloadlength.count)
//        print(payload.count)
//        print(localIp.count)
//        print(port.count)
        
        let length = messagesend.count
//        let string : String=messagesend as String
//        let array: [UInt8] = Array(string.utf8)
//        print("\(array)")
         if(!encryptionMode.elementsEqual(" "))
        {
            let vari = makeEncryption(string: messagesend as String, mode: encryptionMode)
            return vari
        }else
        {
//            let str = messagesend as String
//            let chars: [unichar] = Array(messagesend.utf8)
            let vari1 = messagesend.data(using: String.Encoding.ascii, allowLossyConversion: true)
//            print(messagesend)
//            let byteArray = [UInt8](vari1!)
//            print(byteArray)
            return vari1!
        }
//        print(messagesend)
    
    }
    func utf16ArrayToString (chars: [UInt8]) -> String {
        var string = ""
        for char in chars
        { string.append(Character(UnicodeScalar(char)))
            
        }
        return string
    }
    
    func setSetRequestRaw(password : String, key: String , value : String) {
        self.code = password
        self.functionId = "02"
        let temppayload=key+"="+value
        self.setPayload(payload: temppayload)
        
    }
    
    func makeEncryption(string: String,mode: String) -> Data {
        if(mode.elementsEqual("*"))
        {
//            var string =
             return Encryption().encrRSA(string: string, index: 19)
        }
        else if(mode.elementsEqual("-"))
        {
            return Encryption().encrXTEA(string: string, index: 19)
//            return Encryption().encrXTEA(string: string, index: 19)
        }
        else
        {
            return mode.data(using: String.Encoding(rawValue: String.Encoding.ascii.rawValue), allowLossyConversion: true)!
        }
    }
    func convert()  {
        
    }
    
    
}
