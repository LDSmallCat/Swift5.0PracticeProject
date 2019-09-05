//
//  LDTabBar.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/15.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class LDTabBar: UITabBar {

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for button in subviews where button is UIControl {
            var frame = button.frame
            frame.origin.y = 7
            button.frame = frame
        }
    }

}
