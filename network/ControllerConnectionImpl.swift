//
//  ControllerConnectionImpl.swift
//  BBQ
//
//  Created by Macbook Pro on 24/07/2019.
//  Copyright © 2019 Phaedra. All rights reserved.
//

import Foundation

class ControllerconnectionImpl
{
  
    

    var client: ControllerClient
    static var instance=ControllerconnectionImpl()
    var controller : Controller
    var frontData: [String : String] = [:]
    
    
    init()
    {
        self.client=ControllerClient()
        self.controller = Controller(serial: "654321")
    }
    
    static func getInstance() -> ControllerconnectionImpl
    {
        if(ControllerconnectionImpl.instance==nil)
        {
            ControllerconnectionImpl.instance=ControllerconnectionImpl()
            return ControllerconnectionImpl.instance
        }
        else
        {
            return ControllerconnectionImpl.instance
        }
    }
    
    func getController() -> Controller {
        return self.controller
    }
    func setController(controller: Controller) {
        self.controller=controller
    }
    
    
    func reuqestSetWithoutEncrypt(key: String, value: String, reuqestSetWithoutEncryptCompletionHandler: @escaping (_ controlerResponse: ControllerResponseImpl) -> Void)
    {
        requestSet(key: key, value: value, encryptionMode: "-") {
            (ControllerResponseImpl) in
            reuqestSetWithoutEncryptCompletionHandler(ControllerResponseImpl)
        }
//        return requestSet(key: key, value: value, encryptionMode: "-")
    }
    
    func requestSet(key: String, value: String, encryptionMode: String, requestCompletionHandler: @escaping (_ controlerResponse: ControllerResponseImpl) -> Void)
    {
        let request : ControllerRequestImpl = ControllerRequestImpl()
        request.setSetRequest(password: controller.getPassword(), key: key, value: value)
        client.sendRequest(senderAddr: Util.getWiFiAddress()!, receiverAddr: controller.getIp(), request: request, appId: Util.getAppId(), serial: controller.getSerial(), encryptionMode: encryptionMode, apprelay: connectedOnAppRelay()) { (ControllerResponseImpl) in
            requestCompletionHandler(ControllerResponseImpl)
        }

//    return true
    }
    
    func requestRead(key: String, completionfinal: @escaping (_ controlerResponse: ControllerResponseImpl) -> Void)
    {
    
//        var completion : Bool = false
        let request : ControllerRequestImpl = ControllerRequestImpl()
        request.setReadRequest(password: controller.getPassword(), value: key)
        client.sendRequest(
            senderAddr: Util.getWiFiAddress()!, receiverAddr: controller.getIp(), request: request, appId: Util.getAppId(), serial: controller.getSerial(), encryptionMode: " ", apprelay: connectedOnAppRelay())
        { (ControllerResponseImpl) in
            completionfinal(ControllerResponseImpl)
        }

    }

    func readF11(completionF11: @escaping (_ controlerResponse: ControllerResponseImpl) -> Void)
    {
        let request : ControllerRequestImpl = ControllerRequestImpl()
        request.setF11Request(password: controller.getPassword(), value: "*")
        client.sendRequest(senderAddr: Util.getWiFiAddress()!, receiverAddr: controller.getIp(),
                           request: request,
                           appId: Util.getAppId(),
                           serial: controller.getSerial(),
                           encryptionMode: " ",
                           apprelay: connectedOnAppRelay())
        { (ControllerResponseImpl) in
            completionF11(ControllerResponseImpl)
        }
    }
    
    func requestF11Identified(controllerResponsef11: @escaping (_ controllerResponseF11: ControllerResponseImpl) -> Void)
    {
        readF11 {
            (ControllerResponseImpl) in
            if(ControllerResponseImpl.getPayload().contains("nothing"))
            {
//                print("f11 got no response")
                controllerResponsef11(ControllerResponseImpl)
                //                self.showToast(message: "TimeOut Error Try Again")
            }
            else
            {
                self.setFrontData(frontdata: ControllerResponseImpl.getF11Values())
                controllerResponsef11(ControllerResponseImpl)
                
            }
           
        }
    }
    
    func requestDiscovery(controllerResponse: @escaping (_ responseGot: ControllerResponseImpl) -> Void)
    {
        let request : ControllerRequestImpl = ControllerRequestImpl()
        request.setDiscoveryRequest(password: controller.getPassword())
        client.sendRequest(senderAddr: Util.getWiFiAddress()!, receiverAddr: controller.getIp(),
                           request: request, appId: Util.getAppId(),
                           serial: controller.getSerial(), encryptionMode: " ",
                           apprelay: connectedOnAppRelay())
        {
            (ControllerResponseImpl) in
            controllerResponse(ControllerResponseImpl)
        }

    }
    func requestSetFirmwareUpdate(key: String, value: [UInt8], encryptionMode: String, requestCompletionHandler: @escaping (_ controlerResponse: ControllerResponseImpl) -> Void)
    {
        let request : ControllerRequestImpl = ControllerRequestImpl()
//
        request.setSetFirmWareRequest(password: controller.getPassword(), key: key, value: value)
        client.sendRequestFirmwareIO(senderAddr: Util.getWiFiAddress()!, receiverAddr: controller.getIp(), request: request, appId: Util.getAppId(), serial: controller.getSerial(), encryptionMode: encryptionMode, apprelay: connectedOnAppRelay()) { (ControllerResponseImpl) in
            requestCompletionHandler(ControllerResponseImpl)
        }
        
        //    return true
    }
    
    func connectedOnAppRelay() -> Bool {
        return controller.getIp().contains("apprelay")
    }
    
    func setFrontData(frontdata:[String: String])
    {
        self.frontData=frontdata
    }
    func getFrontData() -> [String :String] {
        return self.frontData
    }
    
    
}
