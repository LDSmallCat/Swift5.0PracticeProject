//
//  VoiceViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/15.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit
// 支持Date和NSDate，默认会将毫秒数转为Date\NSDate
 
struct Student: Convertible {
    var date1: NSDate?
    var date2: NSDate?
    var date3: Date?
    var date4: Date?
    var date5: Date?
    var date6: Date?
    var date7: Date?
}
 
let milliseconds: Int = 1565922866
 
let json: [String: Any] = [
    "date1": milliseconds,
    "date2": Date(timeIntervalSince1970: TimeInterval(milliseconds)),
    "date3": milliseconds,
    "date4": NSDate(timeIntervalSince1970: TimeInterval(milliseconds)),
    "date5": "\(milliseconds)",
    "date6": NSDecimalNumber(string: "\(milliseconds)"),
    "date7": Decimal(string: "\(milliseconds)") as Any
]
 
class VoiceViewController: LDBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let student = json.kk.model(Student.self)
        
        
        guard let stu = student else { return }
        guard let date1 = stu.date1 else { return }
        print(date1)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
