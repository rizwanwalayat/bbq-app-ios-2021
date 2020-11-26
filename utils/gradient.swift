//
//  gradient.swift
//  Aduro
//
//  Created by Macbook Pro on 05/05/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

@IBDesignable
class gradient: UIView {
    
    // the gradient start colour
    @IBInspectable var startColor: UIColor? {
        didSet {
            updateGradient()
        }
    }
    
    @IBInspectable var centerColor: UIColor? {
        didSet {
            updateGradient()
        }
    }
    // the gradient end colour
    @IBInspectable var endColor: UIColor? {
        didSet {
            updateGradient()
        }
    }
    
    // the gradient angle, in degrees anticlockwise from 0 (east/right)
    @IBInspectable var angle: CGFloat = 270 {
        didSet {
            updateGradient()
        }
    }
    
    // the gradient layer
    private var gradient: CAGradientLayer?
    
    // initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
//        installGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       

//        installGradient()
    }
    
    @objc func rotated()  {
        if UIDevice.current.orientation.isLandscape {
//            installGradient()
//            print("---------------------------------------------")
//            print("LANDSCAPE")
//            print(UIScreen.main.bounds)
//            print(self.gradient?.bounds)
//            print(self.bounds)
//            print("---------------------------------------------")
//            updateGradient()
            updateGradientland()
        } else if UIDevice.current.orientation.isPortrait{
            //            installGradient()
//            print("---------------------------------------------")
//            print("PORTRAIT")
//            print(UIScreen.main.bounds)
//            print(self.gradient?.bounds)
//            print(self.bounds)
//            print("---------------------------------------------")
            updateGradientpotrait()
//            updateGradient()
        }
    }
    
    // Create a gradient and install it on the layer
    public func installGradient() {
        // if there's already a gradient installed on the layer, remove it
        if let gradient = self.gradient {
            gradient.removeFromSuperlayer()
        }
        let gradient = createGradient()
//        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
//        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.type=CAGradientLayerType.axial
        self.layer.insertSublayer(gradient, at: 0)
        self.gradient = gradient
    }
    public func installGradientwithvounds(frame:CGRect) {
            // if there's already a gradient installed on the layer, remove it
            if let gradient = self.gradient {
                gradient.removeFromSuperlayer()
            }
            let gradient = createGradient(frame: frame)
    //        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
    //        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
            gradient.type=CAGradientLayerType.axial
            self.layer.insertSublayer(gradient, at: 0)
            self.gradient = gradient
        }
    // create gradient layer
    private func createGradient(frame:CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.type = .conic
        return gradient
    }
    
    
    // Update an existing gradient
    private func updateGradient() {
        if let gradient = self.gradient {
            let startColor = self.startColor ?? UIColor.clear
            let endColor = self.endColor ?? UIColor.clear
            gradient.colors = [startColor.cgColor,centerColor?.cgColor,endColor.cgColor]
            let (start, end) = gradientPointsForAngle(self.angle)
            gradient.startPoint = start
            gradient.endPoint = end
            gradient.frame=self.bounds
        }
    }
    private func updateGradientland() {
           if let gradient = self.gradient {
               let startColor = self.startColor ?? UIColor.clear
               let endColor = self.endColor ?? UIColor.clear
               gradient.colors = [startColor.cgColor,centerColor?.cgColor,endColor.cgColor]
               let (start, end) = gradientPointsForAngle(self.angle)
               gradient.startPoint = start
               gradient.endPoint = end
            var height=self.bounds.height
            var width=self.bounds.width
            if(width>height)
            {
                let temp:CGRect=CGRect(x: 0, y: 0, width: width, height: height)
                gradient.frame=temp
            }else
            {
                let temp:CGRect=CGRect(x: 0, y: 0, width: height, height: width)
                gradient.frame=temp
            }
           }
       }
    private func updateGradientpotrait() {
              if let gradient = self.gradient {
                  let startColor = self.startColor ?? UIColor.clear
                  let endColor = self.endColor ?? UIColor.clear
                  gradient.colors = [startColor.cgColor,centerColor?.cgColor,endColor.cgColor]
                  let (start, end) = gradientPointsForAngle(self.angle)
                  gradient.startPoint = start
                  gradient.endPoint = end
                  gradient.frame=self.bounds

                var height=self.bounds.height
                var width=self.bounds.width
                if(width>height)
                {
                    let temp:CGRect=CGRect(x: 0, y: 0, width: height, height: width)
                    gradient.frame=temp
                }else
                {
                    let temp:CGRect=CGRect(x: 0, y: 0, width: width, height: height)
                    gradient.frame=temp
                }
              }
          }
    public func updateGradient(frame:CGRect) {
           if let gradient = self.gradient {
               let startColor = self.startColor ?? UIColor.clear
               let endColor = self.endColor ?? UIColor.clear
               gradient.colors = [startColor.cgColor,centerColor?.cgColor,endColor.cgColor]
               let (start, end) = gradientPointsForAngle(self.angle)
               gradient.startPoint = start
               gradient.endPoint = end
               gradient.frame=frame
             NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
           }
       }
    
    
    // create gradient layer
    private func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.type = .conic
        return gradient
    }
    
    // create vector pointing in direction of angle
    private func gradientPointsForAngle(_ angle: CGFloat) -> (CGPoint, CGPoint) {
        // get vector start and end points
        let end = pointForAngle(angle)
        //let start = pointForAngle(angle+180.0)
        let start = oppositePoint(end)
        // convert to gradient space
        let p0 = transformToGradientSpace(start)
        let p1 = transformToGradientSpace(end)
//        return (CGPoint(x: 0.0, y: 1.0),CGPoint(x: 1.0, y: 0.0))
        return (p0, p1)
    }
    
    // get a point corresponding to the angle
    private func pointForAngle(_ angle: CGFloat) -> CGPoint {
        // convert degrees to radians
        let radians = angle * .pi / 180.0
        var x = cos(radians)
        var y = sin(radians)
        // (x,y) is in terms unit circle. Extrapolate to unit square to get full vector length
        if (fabs(x) > fabs(y)) {
            // extrapolate x to unit length
            x = x > 0 ? 1 : -1
            y = x * tan(radians)
        } else {
            // extrapolate y to unit length
            y = y > 0 ? 1 : -1
            x = y / tan(radians)
        }
        return CGPoint(x: x, y: y)
    }
    
    // transform point in unit space to gradient space
    private func transformToGradientSpace(_ point: CGPoint) -> CGPoint {
        // input point is in signed unit space: (-1,-1) to (1,1)
        // convert to gradient space: (0,0) to (1,1), with flipped Y axis
        return CGPoint(x: (point.x + 1) * 0.5, y: 1.0 - (point.y + 1) * 0.5)
    }
    
    // return the opposite point in the signed unit square
    private func oppositePoint(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }
    
    // ensure the gradient gets initialized when the view is created in IB
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        installGradient()
        updateGradient()
    }
}
