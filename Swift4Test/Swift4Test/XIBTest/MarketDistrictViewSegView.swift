//
//  MarketDistrictViewSegView.swift
//  Exchange
//
//  Created by Hydra on 2019/6/20.
//  Copyright © 2019 Exchange. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

extension UIButton {
    func segSelect (select:Bool) {
        if(select){
            self.backgroundColor = UIColor.hexadecimalColor(hexadecimal: "#12ADB5")
            self.setTitleColor(UIColor.hexadecimalColor(hexadecimal: "#F4F4F5"), for: .normal)
        }
        else{
            self.backgroundColor = .clear
            self.setTitleColor(UIColor.hexadecimalColor(hexadecimal: "#9CB5C5"), for: .normal)
        }
    }
}

enum MarketDistirctType : Int {
    case optional = 0,
    main,
    creative
}

/// 交易分区顶部视图
class MarketDistrictViewSegView: UIView {

    @IBOutlet weak var optionalBtn: UIButton!
    @IBOutlet weak var firstSepView: UIView!
    @IBOutlet weak var mainDistrictBtn: UIButton!
    @IBOutlet weak var secSepView: UIView!
    @IBOutlet weak var creativeBtn: UIButton!
    @IBOutlet weak var btnBgView: UIView!
    
    
    var disposeBag = DisposeBag()
    @objc dynamic var test : String = ""
    @objc dynamic var selectIndex : Int = 0
    var btnArr : [UIButton] {
        get {
            return [optionalBtn,mainDistrictBtn,creativeBtn]
        }
    }
    
    class func instance() -> MarketDistrictViewSegView {
        
        let view = Bundle.main.loadNibNamed("MarketDistrictViewSegView",
                                 owner: nil,
                                 options: nil)?.first as! MarketDistrictViewSegView
        view.initialize()
        return view
    }


    func initialize() {
        bindModel()
        UIConfig()
    }
    
    func bindModel() {
        optionalBtn.rx.tap.subscribe(onNext: {
            [weak self] in
            self?.selectIndex = MarketDistirctType.optional.rawValue
        }).disposed(by: disposeBag)
        
        mainDistrictBtn.rx.tap.subscribe(onNext: {
            [weak self] in
            self?.selectIndex = MarketDistirctType.main.rawValue
        }).disposed(by: disposeBag)
        
        creativeBtn.rx.tap.subscribe(onNext: {
            [weak self] in
            self?.selectIndex = MarketDistirctType.creative.rawValue
        }).disposed(by: disposeBag)
        
        self.rx.observe(Int.self, "selectIndex").subscribe(onNext:{
            [weak self] (element) in
            self!.btnArr.forEach({ (btn) in
                btn.segSelect(select: btn.tag == element)
            })
        }).disposed(by: disposeBag)
        
        self.rx.observe(Int.self, "selectIndex").map { (element) -> Bool in
            return element != MarketDistirctType.creative.rawValue
            }.bind(to: self.firstSepView.rx.isHidden).disposed(by: disposeBag)
        
        self.rx.observe(Int.self, "selectIndex").map { (element) -> Bool in
            return element != MarketDistirctType.optional.rawValue
            }.bind(to: self.secSepView.rx.isHidden).disposed(by: disposeBag)

        self.selectIndex = MarketDistirctType.optional.rawValue
    }
    
    func UIConfig() {
        btnBgView.layer.cornerRadius = 15.0
        btnBgView.clipsToBounds = true
    }
}
