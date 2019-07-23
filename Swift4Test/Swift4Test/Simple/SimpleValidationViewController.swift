//
//  SimpleValidationViewController.swift
//  Swift4Test
//
//  Created by Hydra on 2019/6/18.
//  Copyright © 2019 毕志锋. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate let minimalUsernameLength = 5
fileprivate let minimalPasswordLength = 5

class SimpleValidationViewController: ViewController {

    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidOutlet: UILabel!
    
    @IBOutlet weak var doSomethingOutlet: UIButton!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        validate()
//        createObservable()
//        observeTest()
//        anyObserver()
        binderTest()
    }
    
    func validate() {
        usernameValidOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        let usernameValid = usernameOutlet.rx.text.orEmpty.map({
            $0.count > minimalUsernameLength
        }).share(replay: 1)
        
        let passwordValid = passwordOutlet.rx.text.orEmpty.map({
            $0.count > minimalPasswordLength
        }).share(replay: 1)
        
        let everythingValid = Observable.combineLatest(usernameValid,passwordValid) {
            $0 && $1
            }.share(replay: 1)
        
        usernameValid.bind(to: passwordOutlet.rx.isEnabled).disposed(by: disposeBag)
        usernameValid.bind(to: usernameValidOutlet.rx.isHidden).disposed(by: disposeBag)
        passwordValid.bind(to: passwordValidOutlet.rx.isHidden).disposed(by: disposeBag)
        everythingValid.bind(to: doSomethingOutlet.rx.isEnabled).disposed(by: disposeBag)
        doSomethingOutlet.rx.tap.subscribe(onNext:{
            [weak self] _ in self?.showAlert()
        }).disposed(by: disposeBag)
    }

    
    func showAlert() {
        let alertView = UIAlertView(
            title: "RxExample",
            message: "This is wonderful",
            delegate: nil,
            cancelButtonTitle: "OK"
        )
        
        alertView.show()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
    }
    
    func createObservable() {
        //create方式创建
        let numbers : Observable<Int> = Observable.create { (observer) -> Disposable in
            
            observer.onNext(0)
            observer.onNext(1)
            observer.onCompleted()
            
            return Disposables.create()
        }
        
        numbers.subscribe({event in
            print(event)
        }).disposed(by: disposeBag)
        
        
        //of方式创建
        let observable : Observable<String> = Observable.of("1","2","3")
//        do在next之前执行
        observable.do(onNext: { (element) in
            print("do \(element)")
        }, afterNext: { (element) in
            print("after \(element)")
        }, onError: { (error) in
            
        }, afterError: { (error) in
            
        }).subscribe(onNext: { (element) in
            print(element)
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("completed")
        }) {
            print("disposed")
        }.disposed(by: disposeBag)
    }
    
    func observeTest() {
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable.map { (element) -> String in
            return "当前索引数目\(element)"
            }.subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }
    
    func anyObserver() {
        //用来描述任意一种观察者
        let observer:AnyObserver<String> = AnyObserver{
            (event) in
            switch event {
            case .next(let data):
                print(data)
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            }
        }
        
        let obserable = Observable.of("A","B","C")
        obserable.subscribe(observer).disposed(by: disposeBag)
        
        //通过绑定操作使用任意观察者
        let observable1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable1.map({"当前索引数目\($0)"}).bind(to: observer).disposed(by: disposeBag)
    }
    
    func binderTest() {
        let observer : Binder<String> = Binder(tempLabel) { (label, text) in
            label.text = text
        }
        
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable.map({
            "当前索引数目\($0)"
        })
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        
    }
}
