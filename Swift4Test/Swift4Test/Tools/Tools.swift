//
//  Tools.swift
//  Swift4Test
//
//  Created by Hydra on 2019/6/23.
//  Copyright © 2019 毕志锋. All rights reserved.
//

import Foundation
import UIKit

class Tools {
    class func VCWithIdentifier(identifier:String,storyBoradName:String) -> UIViewController {
        let stroyBorad = UIStoryboard.init(name: storyBoradName, bundle: nil)
        let vc = stroyBorad.instantiateViewController(withIdentifier: identifier)
        return vc
    }
}
