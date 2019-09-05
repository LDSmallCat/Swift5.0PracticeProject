//
//  SnapKitExtension.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/30.
//  Copyright © 2019 caolaidong. All rights reserved.
//


extension ConstraintView {
    var usnp: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        } else {
            return self.snp
        }
    }
}
