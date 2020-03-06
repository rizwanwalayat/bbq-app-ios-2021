//
//  Extensions.swift
//  Nu
//
//  Created by Pawan Jat on 15/02/17.
//
// Swift extension for Base64 encode/decode in String class

import Foundation


extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}

extension Data {
    func hex(separator:String = "") -> String {
        return (self.map { String(format: "%02X", $0) }).joined(separator: separator)
    }
}
//extension NSData {
//    func hexString() -> NSString {
//        var str = NSMutableString()
//        let bytest = convert(length: self.length, data:&self.bytes)
////        let bytes = UnsafeBufferPointer<UInt8>(start: UnsafePointer(self.bytes), count:self.length)
//
//        for byte in bytest {
//            str.appendFormat("%02hhx", byte)
//        }
//        return str
//    }
//
//    func convert(length: Int, data: UnsafePointer<Int8>) -> [Int8] {
//
//        let buffer = UnsafeBufferPointer(start: data, count: length);
//        return Array(buffer)
//    }
//}
extension String {
    
    func base64Encoded() -> String {
        guard let plainData = (self as NSString).data(using: String.Encoding.ascii.rawValue) else {
            fatalError()
        }
        let base64String = plainData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        return base64String as String
    }
    
    func base64Decoded() -> String? {
//        let decodedData = Data(base64Encoded: self)
//        
////        let decodedString = String(data: decodedData!, encoding: .utf8)
////        return decodedString
        
        if let decodedData = Data(base64Encoded: self),
            let decodedString = String(data: decodedData, encoding: .ascii) {
            print(decodedString) // foo
            return decodedString
        }
        return nil
        
        if let decodedData = NSData(base64Encoded: self, options:NSData.Base64DecodingOptions(rawValue: 0)),
            let decodedString = NSString(data: decodedData as Data, encoding: String.Encoding.utf8.rawValue) {
            return decodedString as String
        } else {
            return self
        }
    }
}


extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx ", $0) }.joined()
    }
    
    init<T>(fromArray values: [T]) {
        var values = values
        self.init(buffer: UnsafeBufferPointer(start: &values, count: values.count))
    }
    
    func toArray<T>(type: T.Type) -> [T] {
        return self.withUnsafeBytes {
            [T](UnsafeBufferPointer(start: $0, count: self.count/MemoryLayout<T>.stride))
        }
    }
}
