//
//  BlockTest.swift
//  Swift4Test
//
//  Created by Hydra on 2019/6/17.
//  Copyright © 2019 毕志锋. All rights reserved.
//

import Foundation
class BlockTest: NSObject {
    func test1 () {
        let names = ["1","2","3","4"]
        func backward(s1:String,s2:String) -> Bool {
            return s1 > s2
        }
        
        func createBlock(block:@escaping (_ s1:String,_ s2:String) -> Bool) {
            block("1","2")
        }
        
        var reversedNames = names.sorted { (s1, s2) -> Bool in
            return s1 > s2
        }
        
        createBlock { (s1, s2) -> Bool in
            return s1 > s2
        }
        
        {
            () -> Void in
            print("1")
        }()
    }
}
