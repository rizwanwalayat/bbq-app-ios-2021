
import Foundation
import JavaScriptCore

 class Encryption {
    
    static let TAG = "Encryption plugin"
    var xteaHelper:XTEAHelper?
    var rsaHelper:RSAHelper?
    
    init() {
    
        xteaHelper = XTEAHelper()
        rsaHelper = RSAHelper()
    }

     func encrXTEA(string: String,index: Int) -> Data
     {
      
//            var pluginResult: CDVPluginResult? = nil
            let fromIndex:Int = index
//            let strTemp = "YW12bjNod2VxdFJ2MDMyNTAzLQIwMjAwODk2MzQxNDM3MzAwOTE5MDg0NDBwYWQgMDI2cmVndWxhdGlvbi5maXhlZF9wb3dlcj0xMDAEICAgICAg"//"b29SWk9hS2lIYnlUMDMyNTAzLQIwMjAwODk2MzQxNDM3MzAwMDMxMTAwNDZwYWQgMDI1cmVndWxhdGlvbi5maXhlZF9wb3dlcj01MAQgICAgICAg"
            let requestString = string //strTemp.base64Decoded()
            let data = requestString.data(using: .utf8, allowLossyConversion: true)

            var byteArray = data?.toArray(type: Int8.self)
        if(byteArray!.count<85)
            {
                while byteArray!.count < 85 {
                    byteArray?.append(Int8("0")!)
                    byteArray?.append(Int8("0")!)
                    byteArray?.append(Int8("0")!)                }
               
                
        }
            let indexesToEncrypt = byteArray?[fromIndex..<(fromIndex + 64)]
            var indexesToEncryptArray = Array(indexesToEncrypt!)
            let encryptedData = self.xteaHelper?.encrypt(bs: &indexesToEncryptArray)//self.rsaHelper?.encrypt(bs: indexesToEncryptArray)

            let totalCount:Int! = (encryptedData?.count)! + fromIndex - 1 //15March changed (+ 19 - 1)
            var i = 0
            for index in fromIndex...totalCount {
                byteArray?[index] = (encryptedData?[i])!
                i += 1
            }
        let inputData:NSData? = NSData(bytes: byteArray, length: (byteArray?.count)!)
//        let datastring = NSString(data: inputData! as Data, encoding: String.Encoding.ascii.rawValue)

//            let byteString = Base64.encode(inputData as Data?)
//            let inputData1 = byteString?.data(using: .ascii, allowLossyConversion: true)

//            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:byteString)
//            let appDelegate = UIApplication.shared.delegate as? AppDelegate
//            self.commandDelegate!.send(
//                pluginResult,
//                callbackId: command.callbackId
//            )

       
        return inputData! as Data
    }
//
//    @objc(setXTEA:) func setXTEA(command: CDVInvokedUrlCommand) -> Bool
//    {
//        self.commandDelegate.run {
//            var pluginResult: CDVPluginResult? = nil
//            self.xteaHelper?.key = command.arguments[0] as? [UInt8]
//            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "key set")
//            self.commandDelegate!.send(
//                pluginResult,
//                callbackId: command.callbackId
//            )
//        }
//        return true
//    }
//
//
//    @objc(getXTEA:) func getXTEA(command: CDVInvokedUrlCommand) -> Bool{
//        self.commandDelegate.run {
//            var pluginResult: CDVPluginResult? = nil
//            if(self.xteaHelper?.key == nil){
//                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:"")
//            }else{
//                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:self.xteaHelper?.key)
//            }
//            self.commandDelegate!.send(
//                pluginResult,
//                callbackId: command.callbackId
//            )
//        }
//        return true
//    }
//
//    @objc(createAndSetXTEA:) func createAndSetXTEA(command: CDVInvokedUrlCommand) -> Bool{
//        self.commandDelegate.run {
//            var pluginResult: CDVPluginResult? = nil
//            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: self.xteaHelper?.loadKey())
//            self.commandDelegate!.send(
//                pluginResult,
//                callbackId: command.callbackId
//            )
//        }
//        return true
//    }
    
    func encrRSA(string: String,index:Int) -> Data
    {
        let fromIndex:Int = index
            let requestString = string
            let data = requestString.data(using: .utf8)
            
            var byteArray = data?.toArray(type: Int8.self)
            let indexesToEncrypt = byteArray?[fromIndex..<(fromIndex + 64)]
            let indexesToEncryptArray = Array(indexesToEncrypt!)
            let encryptedData = self.rsaHelper?.encrypt(bs: indexesToEncryptArray)
//            print(indexesToEncryptArray)
//            print(encryptedData)
            let totalCount:Int! = (encryptedData?.count)! + fromIndex - 1 //15March changed (+ 19 - 1)
            var i = 0
            for index in fromIndex...totalCount {
                byteArray?[index] = (encryptedData?[i])!
                i += 1
            }
        
            let inputData:NSData? = NSData(bytes: byteArray, length: (byteArray?.count)!)
            let datastring = NSString(data: inputData! as Data, encoding: String.Encoding.ascii.rawValue)
//            let returnvalue = String(bytes: byteArray, encoding: .utf8)
        return inputData! as Data
    }

//    @objc(setRSA:) func setRSA(command: CDVInvokedUrlCommand) -> Bool{
//        self.commandDelegate.run {
//            var pluginResult: CDVPluginResult? = nil
//
//            self.rsaHelper?.loadPubKey(key: (command.arguments[0] as? String)!)
//            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Key set")
//
//            self.commandDelegate!.send(
//                pluginResult,
//                callbackId: command.callbackId
//            )
//        }
//        return true
//    }
    
//    @objc(getRSA:) func getRSA(command: CDVInvokedUrlCommand) -> Bool{
//        self.commandDelegate.run {
//            var pluginResult: CDVPluginResult? = nil
//            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: String(describing: self.rsaHelper?.getPubKey()))
//            self.commandDelegate!.send(
//                pluginResult,
//                callbackId: command.callbackId
//            )
//        }
//        return true
//    }
}
