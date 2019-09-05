//
//  Global.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/16.
//  Copyright © 2019 caolaidong. All rights reserved.
//

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let defaultCellHeight: CGFloat = 80

let navgationBarHeight: CGFloat = 44.0

let statusBarHeight: CGFloat = isIphoneX ? 44.0 : 20.0

var topVC: UIViewController? {
    var resultVC: UIViewController?
    
    resultVC = _topVC(UIApplication.shared.keyWindow?.rootViewController)
    while resultVC?.presentedViewController != nil {
        resultVC = _topVC(resultVC?.presentedViewController)
    }
    return resultVC
}

private func _topVC(_ vc: UIViewController?) -> UIViewController? {
      
       if vc is UINavigationController {
               return _topVC((vc as? UINavigationController)?.topViewController)
           } else if vc is UITabBarController {
               return _topVC((vc as? UITabBarController)?.selectedViewController)
           } else {
               return vc
           }
   }

//MARK: print
func lPrint<T>(_ message: T, file: String = #file, function: String = #function, lineNumber: Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):funciton:\(function):line:\(lineNumber)]- \(message)")
    #endif
}

var isIphoneX: Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
        && (max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 812
        || max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 896)
}
