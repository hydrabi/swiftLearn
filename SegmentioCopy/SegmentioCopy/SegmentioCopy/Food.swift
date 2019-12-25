//
//  Food.swift
//  SegmentioCopy
//
//  Created by Hydra on 2019/12/13.
//  Copyright © 2019 毕志锋. All rights reserved.
//

import Foundation

class Food {
    var name: String
    init(name: String) {
        self.name = name
    }

    convenience init() {
        self.init(name: "[Unnamed]")
    }
}

class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
//        指定构造器必须保证它所在类的所有属性都必须先初始化完成，之后才能将其它构造任务向上代理给父类中的构造器。
        super.init(name: name)
//        指定构造器必须在为继承的属性设置新值之前向上代理调用父类构造器。如果没这么做，指定构造器赋予的新值将被父类中的构造器所覆盖。
//        self.name = "1"
        
    }
    override convenience init(name: String) {
        
        self.init(name: name, quantity: 1)
//        便利构造器必须为任意属性（包括所有同类中定义的）赋新值之前代理调用其它构造器。如果没这么做，便利构造器赋予的新值将被该类的指定构造器所覆盖。
        self.quantity = 2
    }
}
