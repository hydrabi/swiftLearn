//
//  CombineViewController.swift
//  Swift4Test
//
//  Created by Hydra on 2019/6/24.
//  Copyright © 2019 毕志锋. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CombineViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        startWithTest()
//        zipTest()
//        combineLatestTest()
        switchLatestest()
        // Do any additional setup after loading the view.
    }
    
    //会在序列开始之前插入一些事件元素。即发出事件消息之前，会先发出这些预先插入的事件消息
    func startWithTest() {
        Observable.of(2,3).startWith(1).subscribe(onNext:{
            print($0)
        }).disposed(by: disposeBag)
    }
    
    //可以将多个observable合并成一个observable序列
    func mergeTest() {
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        Observable.of(subject1,subject2).merge().subscribe(onNext:{
            print($0)
        }).disposed(by: disposeBag)
        
        subject1.onNext(20)
        subject1.onNext(40)
        subject1.onNext(60)
        subject2.onNext(1)
        subject1.onNext(80)
        subject1.onNext(100)
        subject2.onNext(1)
    }
    
    //zip 可以讲多个（两个或者以上）observable序列压缩成一个observable序列
    //而且它会等到每个observable事件 对应地凑齐之后再合并
    //比如我们想同时发送两个请求，只有当两个请求都成功后，再讲两者的请求整合起来继续往下处理
    func zipTest () {
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<String>()
        
        Observable.zip(subject1,subject2) {
            "\($0)\($1)"
            }.subscribe(onNext:{
                print($0)
            }).disposed(by: disposeBag)
        
        subject1.onNext(1)
        subject2.onNext("A")
        subject1.onNext(2)
        subject2.onNext("B")
        subject2.onNext("C")
        subject2.onNext("D")
        subject1.onNext(3)
        subject1.onNext(4)
        subject1.onNext(5)
        
//        1A
//        2B
//        3C
//        4D
    }

    
    
//    该方法同样是将多个（两个或两个以上的）Observable 序列元素进行合并。
//    但与 zip 不同的是，每当任意一个 Observable 有新的事件发出时，它会将每个 Observable 序列的最新的一个事件元素进行合并。
    func combineLatestTest() {
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<String>()
        
        Observable.combineLatest(subject1,subject2){
            "\($0)\($1)"
            }.subscribe(onNext:{
                print($0)
            }).disposed(by: disposeBag)
        
        subject1.onNext(1)
        subject2.onNext("A")
        subject1.onNext(2)
        subject2.onNext("B")
        subject2.onNext("C")
        subject2.onNext("D")
        subject1.onNext(3)
        subject1.onNext(4)
        subject1.onNext(5)
        
//        1A
//        2A
//        2B
//        2C
//        2D
//        3D
//        4D
//        5D
    }
    
    //witchLatest 有点像其他语言的 switch 方法，可以对事件流进行转换。
    //比如本来监听的 subject1，我可以通过更改 variable 里面的 value 更换事件源。变成监听 subject2。
    func switchLatestest() {
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        
        variable.asObservable().switchLatest()
            .subscribe(onNext:{
                print($0)
            }).disposed(by: disposeBag)
        
        subject1.onNext("B")
        subject1.onNext("C")
        
        //改变事件源
        variable.value = subject2
        subject1.onNext("D")
        subject2.onNext("2")
        
        //改变事件源
        variable.value = subject1
        subject2.onNext("3")
        subject1.onNext("E")
    }
}
