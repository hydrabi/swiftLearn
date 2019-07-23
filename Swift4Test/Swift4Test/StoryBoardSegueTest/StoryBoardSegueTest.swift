//
//  StoryBoardSegueTest.swift
//  Swift4Test
//
//  Created by Hydra on 2019/6/23.
//  Copyright © 2019 毕志锋. All rights reserved.
//

import Foundation
import UIKit
class StoryBoardSegueTestViewController: ViewController {
    
    override func viewDidLoad() {
        test1()
    }
    
    func test1 () {
        performSegue(withIdentifier: "test", sender: nil)
    }
    
    func test2() {
        let vc = Tools.VCWithIdentifier(identifier: "test", storyBoradName: "Segue")
        self.show(vc, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
    }
}
