//
//  StringExtension.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/27.
//  Copyright © 2019 caolaidong. All rights reserved.
//

extension String {
    
    func getHeightFor(_ fontSize: CGFloat, _ width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height:CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
    
    func getWidthFor(_ fontSize: CGFloat, _ height: CGFloat = 20) -> CGFloat {
            let font = UIFont.systemFont(ofSize: fontSize)
            let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat.infinity, height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            return ceil(rect.width)
    }
    
    func getHeightFor(_ fontSize: CGFloat, _ width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height) > maxHeight ? maxHeight : ceil(rect.height)
    }
    
    func getWidthFor(_ fontSize: CGFloat, _ height: CGFloat = 20 ,_ maxWidth: CGFloat) -> CGFloat {
            let font = UIFont.systemFont(ofSize: fontSize)
            let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat.infinity, height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            return ceil(rect.width) > maxWidth ? maxWidth : ceil(rect.width)
        }
}
