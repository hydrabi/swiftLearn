//
//  SubjectViewController.swift
//  Swift4Test
//
//  Created by Hydra on 2019/6/21.
//  Copyright © 2019 毕志锋. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SubjectViewController: ViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

//        publishSubject()
//        behaviorSubject()
        replaySubject()
//        behaviorReplayTest1()
//        behaviorReplayTest2()
        // Do any additional setup after loading the view.
    }
    
    //publishSubject是最普通的subject 不需要初始值就能创建
//    publishSubject的订阅者从他们开始订阅的时间点起来，可以收到订阅后的subject发出的新event，不会收到之前的订阅
    func publishSubject() {
        //使用指定泛型类型初始化
        let subject = PublishSubject<String>()
        //没有任何订阅者 不会发出此消息到控制台
        subject.onNext("111")
        
        subject.subscribe(onNext: { str in
            print("第一次订阅",str)
        },onCompleted:{
            print("第一次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
        //当前有一个订阅 则该信息会输出到控制台
        subject.onNext("222")
        
        //第二次订阅subject
        subject.subscribe(onNext: { (str) in
            print("第二次订阅",str)
        }, onCompleted: {
            print("第二次订阅：conCompleted")
        }).disposed(by: disposeBag)
        
        subject.onNext("333")
        //subject结束
        subject.onCompleted()
        //已完成 不会发出该next事件
        subject.onNext("444")
        
        subject.subscribe(onNext: { (str) in
            print("第三次订阅",str)
        }, onCompleted: {
            print("第三次订阅：conCompleted")
        }).disposed(by: disposeBag)
    }
    
//    behaviorSubject需要一个默认初始值来创建
//    当一个订阅者来订阅它的时候，这个订阅者会立即受到behaviorSubjects上一个发出的event。之后就跟正常的状况一样
//    它也会接收到behaviorSubject之后发出的新的event
    func behaviorSubject() {
        //需要一个默认值
        let subject = BehaviorSubject(value: "111")
        
        subject.subscribe(onNext: { (str) in
            print("第一次订阅",str)
        }).disposed(by: disposeBag)
        
        subject.onNext("222")
        
        subject.onError(NSError(domain: "local", code: 0, userInfo: nil))
        
        subject.subscribe { (event) in
            print("第二次订阅",event)
        }.disposed(by: disposeBag)
        
    }
    
    //replaySubject在创建时候需要设置一个bufferSize 表示它对于它发送过的event的缓存个数
//    比如一个replaySubject的buffersize 设置为2，它发出了3个.next的event，那么它会将后两个event缓存起来
//    此时如果有一个subscriber订阅了这个Replaysubject，那么这个subscriber就会立即受到缓存的两个.next的event
//    如果一个subscriber的订阅已经结束的replaysubject，除了会收到缓存的next的event外 还会收到那个终结的error或者
//    complete的event
    
    func replaySubject() {
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        subject.onNext("111")
        subject.onNext("222")
        subject.onNext("333")
        
        subject.subscribe { (event) in
            print("第一次订阅：",event)
        }.disposed(by: disposeBag)
        
        subject.onNext("444")
        
        subject.subscribe { (event) in
            print("第二次订阅",event)
        }.disposed(by: disposeBag)
        
        //结束
        subject.onCompleted()
        
        subject.subscribe { (event) in
            print("第三次订阅",event)
        }.disposed(by: disposeBag)
    }
    
    //接收到上一次的值
    func behaviorReplayTest1() {
        let subject = BehaviorRelay<String>(value: "1")
        subject.asObservable().subscribe { (str) in
            print("第一次",str)
        }.disposed(by: disposeBag)
        
        
        subject.asObservable().subscribe { (str) in
            print("第二次",str)
            }.disposed(by: disposeBag)
        subject.accept("2")
    }
    
    //新值合并到原值 通过accept()与value属性作配合
    func behaviorReplayTest2() {
        let subject = BehaviorRelay<[String]>(value: ["1"])
        
        subject.accept(subject.value + ["2"])
        subject.asObservable().subscribe { (arr) in
            print("第一次",arr)
        }.disposed(by: disposeBag)
        
        subject.accept(subject.value + ["3"])
        subject.asObservable().subscribe { (arr) in
            print("第二次",arr)
            }.disposed(by: disposeBag)
    }
}
