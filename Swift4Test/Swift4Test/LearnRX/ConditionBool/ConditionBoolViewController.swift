//
//  ConditionBoolViewController.swift
//  Swift4Test
//
//  Created by Hydra on 2019/6/24.
//  Copyright © 2019 毕志锋. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ConditionBoolViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        ambTest()
        takeUntil()
    }
    
    func ambTest () {
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        let subject3 = PublishSubject<Int>()
        
        subject1.amb(subject2)
            .amb(subject3)
            .subscribe(onNext:{
            print($0)
        }).disposed(by: disposeBag)
        
        subject2.onNext(1)
        subject1.onNext(20)
        subject2.onNext(2)
        subject1.onNext(40)
        subject3.onNext(0)
        subject2.onNext(3)
        subject1.onNext(60)
        subject3.onNext(0)
        subject3.onNext(0)
    }
    
    //依次判断observable序列的每一个值是否满足给定的条件。当第一个不满足条件的值出现时 它便自动完成
    func takeWhileTest() {
        Observable.of(2,3,4,5,6).takeWhile { (ele) -> Bool in
                ele < 4
            }.subscribe(onNext:{
                print($0)
            }).disposed(by: disposeBag)
    }
    
    //除了订阅源observable，通过takeUntil我们还可以监视另一个observable，即notifier
    //如果notifier发出值或complete通知，那么源observable便自动完成，停止发送事件
    func takeUntil() {
        let source = PublishSubject<String>()
        let notifier = PublishSubject<String>()
        
        source.takeUntil(notifier).subscribe(onNext:{
            print($0)
        }).disposed(by: disposeBag)
        
        source.onNext("a")
        source.onNext("b")
        source.onNext("c")
        source.onNext("d")
        
        //停止接收消息
        notifier.onNext("z")
        
        source.onNext("e")
        source.onNext("f")
        source.onNext("g")
    }
    
    //跳过前面所有满足条件的事件
    //一旦遇到不满足条件的事件，之后就不会再跳过了
    func skipWhile() {
        
    }
}
