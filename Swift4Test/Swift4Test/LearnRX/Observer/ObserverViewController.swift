//
//  ObserverViewController.swift
//  Swift4Test
//
//  Created by Hydra on 2019/12/26.
//  Copyright © 2019 毕志锋. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class ObserverViewController:ViewController {
    override func viewDidLoad() {
        
    }
    
    func anyObserver() {
        //任意观察者
        let observer:AnyObserver<Bool> = AnyObserver { (event) in
            switch event {
            case .next(let result):
                break
            case .completed:
                break
            case .error(let error):
                break
            }
        }
        
        Observable.of(false).subscribe(observer).disposed(by: disposeBag)
    }
    
    func binder() {
        let view = UIView()
        let observer = Observable.of(false)
        let binder:Binder<Bool> = Binder(view) { (view, ishidden) in
            view.isHidden = ishidden
        }
    }
}
