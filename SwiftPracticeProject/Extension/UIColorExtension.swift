//
//  UIColorExtension.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/15.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r:UInt64 ,g:UInt64 , b:UInt64 , a:CGFloat = 1.0) {
            self.init(red: CGFloat(r) / 255.0,
                      green: CGFloat(g) / 255.0,
                      blue: CGFloat(b) / 255.0,
                      alpha: a)
        }
    class var random: UIColor {
        return UIColor(r: UInt64(arc4random_uniform(256)),
                       g: UInt64(arc4random_uniform(256)),
                       b: UInt64(arc4random_uniform(256)))
        }
    func image() -> UIImage {
            let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            context!.setFillColor(self.cgColor)
            context!.fill(rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!
        }
        
        class func hex(hexString: String) -> UIColor {
            var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
            if cString.count < 6 { return UIColor.black }
            
            let index = cString.index(cString.endIndex, offsetBy: -6)
            let subString = cString[index...]
            if cString.hasPrefix("0X") { cString = String(subString) }
            if cString.hasPrefix("#") { cString = String(subString) }
            
            if cString.count != 6 { return UIColor.black }
            
            var range: NSRange = NSMakeRange(0, 2)
            let rString = (cString as NSString).substring(with: range)
            range.location = 2
            let gString = (cString as NSString).substring(with: range)
            range.location = 4
            let bString = (cString as NSString).substring(with: range)
            
            var r: UInt64 = 0x0
            var g: UInt64 = 0x0
            var b: UInt64 = 0x0
            
            
            Scanner(string: rString).scanHexInt64(&r)
            Scanner(string: gString).scanHexInt64(&g)
            Scanner(string: bString).scanHexInt64(&b)
            
   
            return UIColor(r: r, g: g, b: b)
        }
}
