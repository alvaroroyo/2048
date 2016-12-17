//
//  UIColor+HexColor.swift
//  Infinite Road
//
//  Created by Alvaro Royo on 5/12/16.
//  Copyright © 2016 Alvaro Royo. All rights reserved.
//

import UIKit

extension String{
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

extension UIColor{
    class func colorWithHex(hex: String, alpha:Double) -> UIColor{
        
        let red : String = hex.substring(with: 1..<3)
        let green : String = hex.substring(with: 3..<5)
        let blue : String = hex.substring(with: 5..<7)
        
        let redScanner : Scanner = Scanner(string: red)
        let greenScanner : Scanner = Scanner(string: green)
        let blueScanner : Scanner = Scanner(string: blue)
        
        var redInt : UInt32 = UInt32()
        var greenInt : UInt32 = UInt32()
        var blueInt : UInt32 = UInt32()
        
        redScanner.scanHexInt32(&redInt)
        greenScanner.scanHexInt32(&greenInt)
        blueScanner.scanHexInt32(&blueInt)
        
        let redResult = CGFloat(redInt) / 255.0
        let greenResult = CGFloat(greenInt) / 255.0
        let blueResult = CGFloat(blueInt) / 255.0
        
        return UIColor(red: redResult, green: greenResult, blue: blueResult, alpha: CGFloat(alpha))
        
    }
}

extension UIImage{
    class func imageWithColor(color:UIColor) -> UIImage {
        let rect : CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        let context : CGContext = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
}
