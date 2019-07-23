//
//  ViewController.swift
//  Swift4Test
//
//  Created by Hydra on 2019/6/17.
//  Copyright © 2019 毕志锋. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay


#if os(iOS)
import UIKit
typealias OSViewController = UIViewController
#elseif os(macOS)
import Cocoa
typealias OSViewController = NSViewController
#endif

enum API {
    case success(Int)
    case fail(Int)
    
    func getString () -> String {
        var string = ""
        
        switch self {
        case .success( _):
            string = "success"
        case .fail( _):
            string = "fail"
        }
        return string
    }
        
    static func token(username:String,password:String,success:(String) -> Void,failure:(Error) -> Void){
        
    }
    
}

class ViewController: UIViewController {

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    func btnSubscribe () {
        let btn = UIButton.init()
        btn.frame = CGRect.init(x: 10, y: 10, width: 100, height: 100)
        btn.backgroundColor = UIColor.black
        self.view.addSubview(btn)
        //点击订阅
        btn.rx.tap.subscribe ({ (event) in
            
        })
        
        btn.rx.tap.subscribe(onNext: { () in
            
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }, onDisposed: {
            
        })
        
        btn.rx.tap.subscribe(onNext: {
            
        })
    }
    
}

