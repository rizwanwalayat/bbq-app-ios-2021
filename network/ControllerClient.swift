//
//  ControllerClient.swift
//  BBQ
//
//  Created by Macbook Pro on 25/07/2019.
//  Copyright © 2019 Phaedra. All rights reserved.
//

import Foundation
import CocoaAsyncSocket


class ControllerClient: NSObject,GCDAsyncUdpSocketDelegate
{
    var SERVER_IP:String="192.168.4.1"
    let PORT:UInt16 = 8483
    var skt: GCDAsyncUdpSocket!
    var resp : ControllerResponseImpl = ControllerResponseImpl()
    let dispatchGroup = DispatchGroup()
    var gotresponse = false
    var errorfound = false
    var timeout = false
    var timer : Timer!
    let serialQueue = DispatchQueue(label: "Serial Queue") // custom dispatch queues are serial by default

//    var udpsocket = UDPClient?.self
    override init() {
        super.init()
        skt = GCDAsyncUdpSocket(delegate: self, delegateQueue: .main)
    }

   
    func sendRequestFirmwareIO(senderAddr: String, receiverAddr: String ,request: ControllerRequestImpl,appId: String, serial: String,encryptionMode: String,apprelay: Bool ,CompletionHandler: @escaping (ControllerResponseImpl)->())
    {
        semaphore.wait()
        testing=CompletionHandler

        self.resp = ControllerResponseImpl()
        gotresponse = false
        errorfound = false
        timeout = false
        do
        {
            self.skt.close()

            try skt.bind(toPort: 1901)
            try skt.beginReceiving()
            try skt.enableBroadcast(true)
            try skt.enableBroadcast(true)
            
        }
        catch let myError
        {
            print("caught: \(myError)")
        }
        let serialtemp = sanitizeSerial(serial: serial)
        request.setAppId(appid: appId)
        request.setSerial(serial: serialtemp)
        request.setEncryption(mode: encryptionMode)
        if(apprelay==true)
        {
            var ip=Util.getHostIpAddress(hostDomainNama: receiverAddr as CFString )
                                   if(ip != nil)
                                   {
                                       request.setLocalIp(ip: ip!)
                                       request.setPort(port: "1901")
                                       let stringrequest = request.getRawRequestFirmware()
                                       
                                       self.skt.send(stringrequest, toHost: Util.getHostIpAddress(hostDomainNama: receiverAddr as CFString)!, port: 8483, withTimeout: 3, tag: 0)
                                       print("request send " + String(decoding: stringrequest, as: UTF8.self))
                                   }else
                                   {
                                       print("no internet apprelay case")
                                   }
    
            
        }else
        {
            request.setLocalIp(ip: "192.168.4.1")
            //            request.setLocalIp(ip: senderAddr)
            request.setPort(port: "1901")
            let stringrequest = request.getRawRequestFirmware()
            //            print(stringrequest.toArray(type: UInt8.self).count)
//            print(stringrequest.toArray(type: UInt8.self))
            skt.send(stringrequest, toHost: receiverAddr, port: self.PORT, withTimeout: 1, tag: 0)
            
//            print("request send" + String(decoding: stringrequest, as: UTF8.self))
        }
        DispatchQueue.main.async {
        var runtime: Int=0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true)
        { (timer) in
//            var currentSec = timer.timeInterval
            
            // do stuff 42 seconds later
            if(runtime<=7)
            {
                //                print("runing")
                print(self.resp)
                runtime+=1
                if(self.gotresponse)
                {
                    timer.invalidate()
                    //                    print("got response")
//                    CompletionHandler(self.resp)
                }
            }
            else
            {
                //                print("4 sec is over")
                print("timeout error")
                self.skt.close()
                self.resp.setpayload(payload: "nothing")
                self.errorfound = true
                self.gotresponse=false
                self.timeout = true
                timer.invalidate()
                CompletionHandler(self.resp)
                self.semaphore.signal()
            }
            
        }
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        }
        //      while(gotresponse == true || timeout == true || errorfound == true)
        //      {
        //
        //        }

    }
    
    var testing :((ControllerResponseImpl)->())?
    let semaphore = DispatchSemaphore(value: 1)

    func sendRequest(senderAddr: String, receiverAddr: String ,request: ControllerRequestImpl,appId: String, serial: String,encryptionMode: String,apprelay: Bool ,CompletionHandler:  @escaping (ControllerResponseImpl)->())
    {
        semaphore.wait()
//        serialQueue.sync {
            testing=CompletionHandler
                self.resp = ControllerResponseImpl()
            self.gotresponse = false
            self.errorfound = false
            self.timeout = false
                        do
                        {

            //                try skt.enableReusePort(true)
            //                skt.setPreferIPv4()
            //                skt.setIPv6Enabled(false)
                            self.skt.close()
                            try self.skt.bind(toPort: 1901)
                            try skt.enableReusePort(true)

//                            try skt.connect(toHost: SERVER_IP, onPort: PORT)
                            try self.skt.beginReceiving()
                            try self.skt.enableBroadcast(true)
                        }
                        catch let myError
                        {
                            print("caught: \(myError)")
                        }



            let serialtemp = self.sanitizeSerial(serial: serial)
                    request.setAppId(appid: appId)
                    request.setSerial(serial: serialtemp)
                    request.setEncryption(mode: encryptionMode)
                    if(apprelay==true)
                    {
                        var ip=Util.getHostIpAddress(hostDomainNama: receiverAddr as CFString )
                        if(ip != nil)
                        {
                            request.setLocalIp(ip: ip!)
                            request.setPort(port: "1901")
                            let stringrequest = request.getRawRequest()
                            
                            self.skt.send(stringrequest, toHost: Util.getHostIpAddress(hostDomainNama: receiverAddr as CFString)!, port: 8483, withTimeout: 3, tag: 0)
                            print("request send " + String(decoding: stringrequest, as: UTF8.self))
                        }else
                        {
                            print("no internet apprelay case")
                        }

                    }else
                    {
                        request.setLocalIp(ip: "192.168.4.1")
            //            request.setLocalIp(ip: senderAddr)
                        request.setPort(port: "1901")
                        let stringrequest = request.getRawRequest()
            //            print(stringrequest.toArray(type: UInt8.self).count)
            //            print(stringrequest.toArray(type: UInt8.self))
                        self.skt.send(stringrequest, toHost: receiverAddr, port: self.PORT, withTimeout: 1, tag: 0)

                        print("request send " + String(decoding: stringrequest, as: UTF8.self))
                    }
        DispatchQueue.main.async {
//                   print("This is run on the main queue, after the previous code in outer block")
            var runtime: Int=0
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true)
                                { (timer) in
                                    if(runtime<=7)
                                    {
                                        print(self.resp)
                                        runtime+=1
                                        if(self.gotresponse)
                                        {
                                            timer.invalidate()
            //                                CompletionHandler(self.resp)
                                        }
                                    }
                                    else
                                    {
                                        self.skt.close()
                                        print("timeout error")
                                        self.resp.setpayload(payload: "nothing")
                                        self.errorfound = true
                                        self.gotresponse=false
                                        self.timeout = true
                                        timer.invalidate()
                                        CompletionHandler(self.resp)
                                        self.semaphore.signal()
                                    }

                                }
            RunLoop.current.add(self.timer, forMode: RunLoop.Mode.common)
               }
                    
//            semaphore.signal()

//        }
        
    
        
    }
    


  
    func sanitizeSerial(serial: String) -> String {
        var temp : String = serial
        if temp.count<6
        {
            temp.insert("0", at: temp.startIndex)
        }
        return temp
    }
    
    
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?)
    {
//        print("got response")
        self.gotresponse = true
        var incomingDisc:String = String(data: data as Data, encoding: String.Encoding(rawValue: String.Encoding.ascii.rawValue))!
        print("response : " + incomingDisc)
        self.resp.setData(response: data)
        skt.close()
        timer.invalidate()
        testing!(self.resp)
        semaphore.signal()


    }
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?)
    {
        print("data not send \(String(describing: error))")
//        errorfound = true
//        self.skt.close()
        print("timeout error")
        self.resp.setpayload(payload: "nothing")
        self.errorfound = true
        self.gotresponse=false
        self.timeout = true
        timer.invalidate()
        skt.close()
        testing!(self.resp)
        semaphore.signal()
    }
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        print("did Not Connect \(error)")
    }
    func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
        print("did connect")
        
    }
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
//        print("data send " )

//        GCDAsyncUdpSocket.host(fromAddress: T##Data)
//        GCDAsyncUdpSocket.host(fromAddress: sock.connectedPort())
//        print(" address " + String(data: sock.connectedAddress() as! Data, encoding: String.Encoding(rawValue: String.Encoding.ascii.rawValue))!)
//        print(" port " + String(sock.connectedPort()))
    }
    func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
        errorfound = true
//        print("socket close")
    }
}


protocol IControllerDelegate {
    func response() -> String
}
