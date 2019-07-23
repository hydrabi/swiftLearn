//
//  FilterViewController.swift
//  Swift4Test
//
//  Created by Hydra on 2019/6/23.
//  Copyright © 2019 毕志锋. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FilterViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        filterTest()
//        distinctUntilChanged()
//        singleTest()
//        elementAtTest()
//        ignoreElementsTest()
//        takeTest()
//        takeLastTest()
//        skipTest()
//        sampleTest()
        debounceTest()
    }
    
    //过滤掉不符合要求的事件
    func filterTest() {
        Observable.of(2,30,22,5,60,3,40,9).filter({
            $0 > 10
        }).subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }
    
    //过滤掉连续重复的事件
    func distinctUntilChanged() {
        Observable.of(1,2,3,1,1,4).distinctUntilChanged().subscribe(onNext:{
            print($0)
        }).disposed(by: disposeBag)
    }
    
    //限制只发送一次事件 或者满足条件的第一个事件
    //如果存在多个事件或者没有事件都会发出一个error
    //如果只有一个事件则不会发出error事件
    func singleTest() {
        Observable.of(1,2,3,4).single({
            $0 == 2
        }).subscribe(onNext:{
            print($0)
        }).disposed(by: disposeBag)
        
        Observable.of("A","B","C").single().subscribe(onNext:{
            print($0)
        }).disposed(by: disposeBag)
    }
    
    //elementAt 只处理在指定位置的事件
    func elementAtTest() {
        Observable.of(1,2,3,4,5).elementAt(2).subscribe(onNext:{
            print($0)
        }).disposed(by: disposeBag)
    }
    
    //可以忽略掉所有的元素，只发出error或者complete事件
    //如果我们并不关心observable的任何元素，只想知道observable在什么时候终止，那就可以使用ignorelements
    func ignoreElementsTest() {
        Observable.of(1,2,3,4).ignoreElements().subscribe({
            print($0)
        }).disposed(by: disposeBag)
    }
    
    //仅发送observable序列中的前n个事件在满足数量之后会自动complete
    func takeTest() {
        Observable.of(1,2,3,4).take(2).subscribe(onNext: { (element) in
            print(element)
        },  onCompleted: {
            print("completed")
        }).disposed(by: disposeBag)
    }
    
    //仅发送observable序列中的后n个事件
    func takeLastTest() {
        Observable.of(1,2,3,4).takeLast(1).subscribe(onNext: { (element) in
            print(element)
        },  onCompleted: {
            print("completed")
        }).disposed(by: disposeBag)
    }
    
    //跳过源observable序列发出的前n个事件
    func skipTest() {
        Observable.of(1,2,3,4)
            .skip(2)
            .subscribe(onNext:{
            print($0)
        }).disposed(by: disposeBag)
    }
    
    //sample除了订阅源observable外，还可以监视另外一个observable，即notifier
    //每当收到notifier事件，就会从源序列取一个最新的事件并发送，而如果两次notifier事件之间没有源序列的事件，则不发送值
    func sampleTest() {
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<String>()
        
        source.sample(notifier).subscribe(onNext:{
            print($0)
        }).disposed(by: disposeBag)
        
        source.onNext(1)
        //让源序列接收消息
        notifier.onNext("A")
        
        source.onNext(2)
        
        notifier.onNext("B")
        notifier.onNext("C")
        
        source.onNext(3)
        source.onNext(4)
        
        //让源序列接收消息
        notifier.onNext("D")
        
        source.onNext(5)
        
        //让源序列接收消息
        notifier.onCompleted()
    }
    
    //debounce操作符可以用来过滤掉高频产生的元素，它只会发出这种元素，该元素产生后，一段时间内没有新元素产生
    //换句话就是，队列中的元素y如果和下一个元素的间隔小于指定的时间间隔，那么这个元素将会被过滤掉
    func debounceTest() {
        let times = [
            ["value":1,"time":0.1],
            ["value":2,"time":1.1],
            ["value":3,"time":1.2],
            ["value":4,"time":1.2],
            ["value":5,"time":1.4],
            ["value":6,"time":2.1],
        ]
        
        //生成对应的observable序列并订阅
//        Observable.from(times).flatMap { (item:[String:Any]) in
//            return Observable.of(Int(item["value"]!))
//                .delaySubscription(Double(item["time"]!), scheduler: MainScheduler.instance)
//                .debounce(0.5, scheduler: MainScheduler.instance)
//        }
        
        Observable.from(times).flatMap {
            item in
            return Observable.of(Int(item["value"]!))
                .delaySubscription(Double(item["time"]!),
                                   scheduler: MainScheduler.instance)
            }.debounce(DispatchTimeInterval.milliseconds(500),
                       scheduler: MainScheduler.instance).subscribe(onNext:{
                print($0)
            }).disposed(by: disposeBag)
    }
}
