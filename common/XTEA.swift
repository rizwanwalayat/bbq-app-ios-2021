//
//  XTEA.swift
//  Nu
//
//  Created by Pawan Jat on 13/02/17.
//
//

import Foundation
import JavaScriptCore


public class XTEA{
 
    //MARK:- Veriable declaration
//    private let DELTA:Int62? = NSNumber(value: 0x9E3779B9).int64Value
    private let ALIGN:Int? = 8
    private var k0:Int32? = 0,k1:Int32? = 0,k2:Int32? = 0,k3:Int32? = 0,k4:Int32? = 0,k5:Int32? = 0,k6:Int32? = 0,k7:Int32? = 0,k8:Int32? = 0,k9:Int32? = 0,k10:Int32? = 0,k11:Int32? = 0,k12:Int32? = 0,k13:Int32? = 0,k14:Int32? = 0,k15:Int32? = 0,k16:Int32? = 0,k17:Int32? = 0,k18:Int32? = 0,k19:Int32? = 0,k20:Int32? = 0,k21:Int32? = 0,k22:Int32? = 0,k23:Int32? = 0,k24:Int32? = 0,k25:Int32? = 0,k26:Int32? = 0,k27:Int32? = 0,k28:Int32? = 0,k29:Int32? = 0,k30:Int32? = 0,k31:Int32? = 0,k32:Int32? = 0,k33:Int32? = 0,k34:Int32? = 0,k35:Int32? = 0,k36:Int32? = 0,k37:Int32? = 0,k38:Int32? = 0,k39:Int32? = 0,k40:Int32? = 0,k41:Int32? = 0,k42:Int32? = 0,k43:Int32? = 0,k44:Int32? = 0,k45:Int32? = 0,k46:Int32? = 0,k47:Int32? = 0,k48:Int32? = 0,k49:Int32? = 0,k50:Int32? = 0,k51:Int32? = 0,k52:Int32? = 0,k53:Int32? = 0,k54:Int32? = 0,k55:Int32? = 0,k56:Int32? = 0,k57:Int32? = 0,k58:Int32? = 0,k59:Int32? = 0,k60:Int32? = 0,k61:Int32? = 0,k62:Int32? = 0,k63:Int32? = 0
    
    
    public func unsignedRightShift (lhs: Int32, rhs: Int32) -> Int32 {
//        return ((lhs >> rhs) & 0xFFFFFFF)
        return Int32(bitPattern: UInt32(bitPattern: lhs) >> UInt32(rhs))

    }

    

    //MARK:- Other methods
    public func setKey(b: [UInt8]) -> Void {
        let DELTA: Int32 = -1640531527
        
        var key: [Int32] = []
        for i in 0...3 {
            let count: Int = i * 4
            let i1 = (Int32(b[count]) << 24)
            let i2 = (Int32(b[count + 1]) & 255) << 16
            let i3 = (Int32(b[count + 2]) & 255) << 8
            let i4 = Int32(b[count + 3]) & 255
            key.append(i1 + (i2) + (i3) + (i4))
        }
        var sum: Int32 = 0
        var r: [Int32] = []
        for _ in 0...31 {
            
            let w = sum.addingReportingOverflow(key[Int(sum & 3)])
//            let w = Int32.addWithOverflow(sum, key[Int(sum & 3)])
            r.append(w.0)
//            let wrap = Int32.addWithOverflow(sum, DELTA)
            let wrap=sum.addingReportingOverflow(DELTA)
            sum = wrap.0
            let wrapAgain = sum.addingReportingOverflow(key[Int(rightShiftWithZeroFill(num: sum, by: 11) & 3)])
//            let wrapAgain = Int32.addWithOverflow(sum, key[Int(rightShiftWithZeroFill(num: sum, by: 11) & 3)])
            r.append(wrapAgain.0)
        }
        k0 = r[0]; k1 = r[1]; k2 = r[2]; k3 = r[3]; k4 = r[4]; k5 = r[5]; k6 = r[6]; k7 = r[7];
        k8 = r[8]; k9 = r[9]; k10 = r[10]; k11 = r[11]; k12 = r[12]; k13 = r[13]; k14 = r[14]; k15 = r[15];
        k16 = r[16]; k17 = r[17]; k18 = r[18]; k19 = r[19]; k20 = r[20]; k21 = r[21]; k22 = r[22]; k23 = r[23];
        k24 = r[24]; k25 = r[25]; k26 = r[26]; k27 = r[27]; k28 = r[28]; k29 = r[29]; k30 = r[30]; k31 = r[31];
        k32 = r[32]; k33 = r[33]; k34 = r[34]; k35 = r[35]; k36 = r[36]; k37 = r[37]; k38 = r[38]; k39 = r[39];
        k40 = r[40]; k41 = r[41]; k42 = r[42]; k43 = r[43]; k44 = r[44]; k45 = r[45]; k46 = r[46]; k47 = r[47];
        k48 = r[48]; k49 = r[49]; k50 = r[50]; k51 = r[51]; k52 = r[52]; k53 = r[53]; k54 = r[54]; k55 = r[55];
        k56 = r[56]; k57 = r[57]; k58 = r[58]; k59 = r[59]; k60 = r[60]; k61 = r[61]; k62 = r[62]; k63 = r[63];
    }
    
    func rightShiftWithZeroFill(num: Int32, by: Int32) -> Int32 {
        return ((num >> by) & 0xFFFFFFF)
    }
    
    public func encrypt(bytes:inout [Int8], off:Int, length:Int){
        if(length  % ALIGN! != 0){
            //throw Exception
        }
        
        var count = 0
        while (count < (off + length - 1)) {
            encryptBlock(inByte: bytes, out: &bytes, off: count)
            count += 8
        }
    }
    
    public func decrypt(bytes:inout [Int8], off:Int, length:Int){
        if(length  % ALIGN! != 0){
            //throw Exception
        }
        for var i in off..<(off + length) {
            decryptBlock(inByte: bytes, out: &bytes, off: i)
            i += 8
        }
    }
    
    private func encryptBlock(inByte:[Int8], out:inout [Int8], off:Int){
        let firstValY:Int32 = ((Int32(inByte[off])) << 24)
        let secondValY:Int32 = (((Int32(inByte[off+1])) & 255) << 16)
        let thirdValY:Int32  = ((Int32((inByte[off+2])) & 255) << 8)
        let fourthValY:Int32 = ((Int32(inByte[off+3])) & 255)
        var y:Int32 = firstValY | secondValY | thirdValY | fourthValY
        
        let firstValZ:Int32 = ((Int32(inByte[off+4])) << 24)
        let secondValZ:Int32 = ((Int32((inByte[off+5])) & 255) << 16)
        let thirdValZ:Int32  = ((Int32((inByte[off+6])) & 255) << 8)
        let fourthValZ:Int32 = ((Int32(inByte[off+7])) & 255)
        var z:Int32 = firstValZ | secondValZ | thirdValZ | fourthValZ
        
        //js code to right shift the bit
        let jsSourceFirst = "var calculateBitOperation = function(k,z,y) { var r= y + ((((z << 4) ^ (z >>> 5)) + z) ^ k); return r;}"
        let context = JSContext()
        context?.evaluateScript(jsSourceFirst)
        let calculateBitOperation = context?.objectForKeyedSubscript("calculateBitOperation")
        
        let jsSourceSecond = "var calculateBitOperationSecond = function(k,z,y) { var r= z + ((((y >>> 5) ^ (y << 4)) + y) ^ k); return r;}"
        let contextSecond = JSContext()
        contextSecond?.evaluateScript(jsSourceSecond)
        let calculateBitOperationSecond = contextSecond?.objectForKeyedSubscript("calculateBitOperationSecond")
        
        var resultFirst = calculateBitOperation?.call(withArguments: [k0!,z,y])
        y = (resultFirst?.toInt32())!
        
        var resultSecond = calculateBitOperationSecond?.call(withArguments: [k1!,z,y])
        z = (resultSecond?.toInt32())!
        
        resultFirst = calculateBitOperation?.call(withArguments: [k2!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k3!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k4!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k5!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k6!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k7!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k8!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k9!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k10!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k11!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k12!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k13!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k14!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k15!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k16!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k17!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k18!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k19!,z,y])
        z = (resultSecond?.toInt32())!
        
        resultFirst = calculateBitOperation?.call(withArguments: [k20!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k21!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k22!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k23!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k24!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k25!,z,y])
        z = (resultSecond?.toInt32())!
        
        resultFirst = calculateBitOperation?.call(withArguments: [k26!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k27!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k28!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k29!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k30!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k31!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k32!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k33!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k34!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k35!,z,y])
        z = (resultSecond?.toInt32())!
        
        resultFirst = calculateBitOperation?.call(withArguments: [k36!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k37!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k38!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k39!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k40!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k41!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k42!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k43!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k44!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k45!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k46!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k47!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k48!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k49!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k50!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k51!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k52!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k53!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k54!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k55!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k56!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k57!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k58!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k59!,z,y])
        z = (resultSecond?.toInt32())!

        resultFirst = calculateBitOperation?.call(withArguments: [k60!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k61!,z,y])
        z = (resultSecond?.toInt32())!
        
        resultFirst = calculateBitOperation?.call(withArguments: [k62!,z,y])
        y = (resultFirst?.toInt32())!
        
        resultSecond = calculateBitOperationSecond?.call(withArguments: [k63!,z,y])
        z = (resultSecond?.toInt32())!
        
        out[off] = NSNumber(value: (y >> 24)).int8Value
        out[off+1] = NSNumber(value: (y >> 16)).int8Value
        out[off+2] = NSNumber(value: (y >> 8)).int8Value
        out[off+3] = NSNumber(value: (y)).int8Value
        
        out[off+4] = NSNumber(value: (z >> 24)).int8Value
        out[off+5] = NSNumber(value: (z >> 16)).int8Value
        out[off+6] = NSNumber(value: (z >> 8)).int8Value
        out[off+7] = NSNumber(value: (z)).int8Value
    }
    
    private func decryptBlock(inByte:[Int8], out:inout [Int8], off:Int){
        let firstValY:Int32 = ((Int32(inByte[off])) << 24)
        let secondValY:Int32 = (((Int32(inByte[off+1])) & 255) << 16)
        let thirdValY:Int32  = ((Int32((inByte[off+2])) & 255) << 8)
        let fourthValY:Int32 = ((Int32(inByte[off+3])) & 255)
        var y:Int32 = firstValY | secondValY | thirdValY | fourthValY
        
        let firstValZ:Int32 = ((Int32(inByte[off+4])) << 24)
        let secondValZ:Int32 = ((Int32((inByte[off+5])) & 255) << 16)
        let thirdValZ:Int32  = ((Int32((inByte[off+6])) & 255) << 8)
        let fourthValZ:Int32 = ((Int32(inByte[off+7])) & 255)
        var z:Int32 = firstValZ | secondValZ | thirdValZ | fourthValZ
//
//        z=z.addingReportingOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)).addingReportingOverflow(y).0 ^ k63!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k63!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k62!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k61!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k60!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k59!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k58!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k57!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k56!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k55!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k54!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k53!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k52!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k51!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k50!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k49!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k48!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k47!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k46!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k45!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k44!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k43!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k42!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k41!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k40!).0
//        
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k39!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k38!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k37!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k36!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k35!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k34!).0
//        
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k33!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k32!).0
//        
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k31!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k30!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k29!).0
//        
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k28!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k27!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k26!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k25!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k24!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k23!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k22!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k21!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k20!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k19!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k18!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k17!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k16!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k15!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k14!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k13!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k12!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k11!).0
//        
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k10!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k9!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k8!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k7!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k6!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k5!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k4!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k3!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k2!).0
//        z = Int32.subtractWithOverflow(z, Int32.subtractWithOverflow((unsignedRightShift(lhs: y, rhs: 5) ^ (y << 4)), y).0 ^ k1!).0
//        y = Int32.subtractWithOverflow(y, Int32.subtractWithOverflow(((z << 4)) ^ unsignedRightShift(lhs: z, rhs: 5), y).0 ^ k0!).0
//        
        
        out[off] = NSNumber(value: (y >> 24)).int8Value
        out[off+1] = NSNumber(value: (y >> 16)).int8Value
        out[off+2] = NSNumber(value: (y >> 8)).int8Value
        out[off+3] = NSNumber(value: (y)).int8Value
        
        out[off+4] = NSNumber(value: (z >> 24)).int8Value
        out[off+5] = NSNumber(value: (z >> 16)).int8Value
        out[off+6] = NSNumber(value: (z >> 8)).int8Value
        out[off+7] = NSNumber(value: (z)).int8Value
    }
    
    public func getKeyLength() -> Int {
        return 16
    }
}
