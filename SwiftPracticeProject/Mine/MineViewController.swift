//
//  MineViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/15.
//  Copyright © 2019 caolaidong. All rights reserved.
//

struct Dog: Convertible {
    var name: String = ""
    var weight: Double = 0.0
}

struct Person: Convertible {

    var name: String = ""
    var pet = [[Dog]]()
    
   func kj_modelValue(from jsonValue: Any?, _ property: Property) -> Any? {

     if property.name != "pet" { return jsonValue }
    
        return (jsonValue as? [[[String: Any]]])?.map {
            modelArray(from: $0, Dog.self) }
    }
    
//    func kj_modelValue(from jsonValue: Any?, _ property: Property) -> Any? {
//
//        if property.name != "pet" { return jsonValue }
//
//
//        guard let doubleArray = jsonValue as? [Any] else { return [] }
//        var pet = [[Dog]]()
//
//        for element in doubleArray {
//            //数组里面是字典
//            guard let arr = element as? [[String: Any]] else { return [] }
//            //转为数组模型
//            pet.append(modelArray(from: arr, Dog.self))
//        }
//        return pet
//    }
}

class MineViewController: LDBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.red
        
        let json: [String: Any] = [
            "name": "Jack",
            "pet": [
                        ["name": "Wang1", "weight": 109.51],
                        ["name": "Wang2", "weight": 109.52]
                   ]
        ]
        
        let person = json.kj.model(Person.self)
        print(person)
       
        
    }
    
//    override func configNavigationBar() {
//        super.configNavigationBar()
//        (navigationController as? LDNavigationViewController)?.barStyle(.clear)
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
