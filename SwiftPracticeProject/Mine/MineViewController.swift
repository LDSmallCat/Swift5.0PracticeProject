//
//  MineViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/15.
//  Copyright © 2019 caolaidong. All rights reserved.
//

struct MineModel: Convertible {
    let icon = ""
    let title = ""
}


class MineViewController: LDBaseViewController {
    
    var dataArray: [[MineModel]] = []
    
    
    private lazy var myArray: Array = {
            return [
                [
                      [
                        "icon":  "mine_vip",
                        "title": "我的VIP"
                      ],
                      [
                        "icon":"mine_coin",
                        "title": "充值妖气币"
                      ]
                ],
                
                    [["icon":"mine_accout", "title": "消费记录"],
                     ["icon":"mine_subscript", "title": "我的订阅"],
                     ["icon":"mine_seal", "title": "我的封印图"]],
                    
                    [
                         ["icon":"mine_message", "title": "我的消息/优惠券"],
                         ["icon":"mine_cashew", "title": "妖果商城"],
                         ["icon":"mine_freed", "title": "在线阅读免流量"]
                    ],
                    
                    [
                         ["icon":"mine_feedBack", "title": "帮助中心"],
                         ["icon":"mine_mail", "title": "我要反馈"],
                         ["icon":"mine_judge", "title": "给我们评分"],
                         ["icon":"mine_author", "title": "成为作者"],
                         ["icon":"mine_setting", "title": "设置"]
                   ]
        ]
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.red
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for element in myArray {
            dataArray.append(modelArray(from: element, MineModel.self))
        }
        
        
    }

}

