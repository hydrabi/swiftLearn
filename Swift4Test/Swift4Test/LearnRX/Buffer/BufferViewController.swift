//
//  BufferViewController.swift
//  Swift4Test
//
//  Created by Hydra on 2019/6/22.
//  Copyright © 2019 毕志锋. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BufferViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        bufferTest()
//        windowTest()
//        mapTest()
//        flatmapTest()
//        flatmaplatestTest()
//        flatMapFirstTest()
//        concatMapTest()
//        scanTest()
        groupByTest()
    }
    
//  当元素打到某个数量，或者经过了特定的时间，它就会将这个元素集合发送出来
    func bufferTest() {
        let subject = PublishSubject<String>()
        subject.buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance).subscribe {
            print($0)
        }.disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("a")
        subject.onNext("a")
        
        subject.onNext("b")
        subject.onNext("b")
        subject.onNext("b")
    }
    
    //周期性地将元素以observable的形态发送出来 实时发出元素序列
    func windowTest() {
        let subject = PublishSubject<String>()
        subject.window(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
            .subscribe(onNext:{[weak self]  in
                print("subscribe:\($0)")
                $0.asObservable().subscribe(onNext: { (str) in
                    print(str)
                }).disposed(by: self!.disposeBag)
                
        }).disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
    }
    
    func mapTest() {
        Observable.of(1,2,3).map {
                $0 * 10
            }.subscribe(onNext:{
                print($0)
            }).disposed(by: disposeBag)
    }
    
    func flatmapTest() {
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "B")
        
        let variable = Variable(subject1)
        let variable2 = Variable(subject2)
        
        variable.asObservable().flatMap({
            $0
        }).subscribe(onNext:{
            print($0)
        }).disposed(by: disposeBag)
        
        variable2.asObservable().subscribe(onNext:{
            print($0)
        }).disposed(by: disposeBag)
    }
    
    func flatmaplatestTest() {
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        
        variable.asObservable()
            .flatMapLatest { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
    }
    
    func flatMapFirstTest() {
        let disposeBag = DisposeBag()
        
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        
        variable.asObservable()
            .flatMapFirst { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
    }
    
    //前一个发送完毕后 后一个才会发送元素
    func concatMapTest() {
        let disposeBag = DisposeBag()
        
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        
        variable.asObservable()
            .concatMap{ $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
        subject1.onCompleted()
    }
    
    //先给一个初始化的数 然后不断的拿前一个结果和最新的值进行处理操作
    func scanTest() {
        Observable.of(1,2,3,4,5).scan(0) { (acum, elem) -> Int in
            return acum + elem
        }
            .subscribe(onNext:{
                print($0)
            }).disposed(by: disposeBag)
    }
    
    func groupByTest() {
        Observable<Int>.of(0,1,2,3,4,5).groupBy { (element) -> String in
            return element % 2 == 0 ? "偶数":"基数"
            }.subscribe(onNext:{
                [weak self] group in
                group.asObservable().subscribe(onNext: {
                    print(group.key,$0)
                }).disposed(by: self!.disposeBag)
            })
    }
}
