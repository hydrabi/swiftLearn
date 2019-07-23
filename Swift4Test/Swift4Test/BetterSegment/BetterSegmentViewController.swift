//
//  BetterSegmentViewController.swift
//  Swift4Test
//
//  Created by Hydra on 2019/6/19.
//  Copyright © 2019 毕志锋. All rights reserved.
//

import UIKit
import Segmentio

class BetterSegmentViewController: ViewController,SideMenuManagerViewControllerDelegate {

    var segmentioView : Segmentio!
    var sideManager : CoverMenuManagerViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSeg()
        createDistrictView()
        
        let vc = UIViewController.init()
        vc.view.backgroundColor = .yellow
        sideManager = CoverMenuManagerViewController.init(menuViewController: vc, parentVC: self)
        sideManager.bind(delegate: self)
    }
    
    @IBAction func test1(_ sender: Any) {
        if(sideManager.hadShow){
            sideManager.dismissMenuViewController()
        }
        else{
            sideManager.presentMenuViewController()
        }
    }
    
    func menuDidAppear() {
        
    }
    
    func menuDidDisappear() {
        
    }
    
    @IBAction func test(_ sender: Any) {
        if(sideManager.hadShow){
            sideManager.dismissMenuViewController()
        }
        else{
            sideManager.presentMenuViewController()
        }
    }
    
    func createSeg() {
        let segmentioViewRect = CGRect(x: 60, y: 100, width: 240, height: 30)
        segmentioView = Segmentio(frame: segmentioViewRect)
        segmentioView.layer.cornerRadius = 15.0
        segmentioView.layer.masksToBounds = true
        segmentioView.selectedSegmentioIndex = 0
        view.addSubview(segmentioView)
        
        var segmentContent = [SegmentioItem]()
        let firstItem = SegmentioItem (title: "自选", image: nil)
        let secondItem = SegmentioItem (title: "主区", image: nil)
        let thirdItem = SegmentioItem (title: "创新区", image: nil)
        let fourItem = SegmentioItem (title: "创新区", image: nil)
        segmentContent.append(firstItem)
        segmentContent.append(secondItem)
        segmentContent.append(thirdItem)
        segmentContent.append(fourItem)
        
        let horOpt = SegmentioHorizontalSeparatorOptions(
            type: .topAndBottom,
            height: 1,
            color: .clear
        )
        
        let verOpt = SegmentioVerticalSeparatorOptions(
            ratio: 0.5,
            color: .white
        )
        
        let state = SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.systemFont(ofSize: 13),
                titleTextColor: UIColor.init(red: 156/255, green: 181/255, blue: 197/255, alpha: 1)
            ),
            selectedState: SegmentioState(
                backgroundColor: UIColor.init(red: 18/255, green: 173/255, blue: 181/255, alpha: 1),
                titleFont: UIFont.systemFont(ofSize: 13),
                titleTextColor: .white
            ),
            highlightedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.systemFont(ofSize: 13),
                titleTextColor: .white
            )
        )
        
        segmentioView.setup(content: segmentContent,
                            style: .onlyLabel,
                            options: SegmentioOptions(backgroundColor: .black,
                                                      segmentPosition: .fixed(maxVisibleItems: 3),
                                                      scrollEnabled: true,
                                                      indicatorOptions: nil,
                                                      horizontalSeparatorOptions: horOpt, verticalSeparatorOptions: verOpt, imageContentMode: .scaleAspectFit, labelTextAlignment: .center, labelTextNumberOfLines: 1,
                                                      segmentStates: state,
                                                      animationDuration: 0.3))
    }
    
    
    func createDistrictView () {
//        let view1 = MarketDistrictViewSegView.instance()
        let view2 = MarketDistrictViewSegView.instance()
        
//        view1.frame = CGRect(x: 10, y: 200, width: UIScreen.main.bounds.width, height: 46)
        view2.frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: 46)
//        view.addSubview(view1)
        view.addSubview(view2)
    }
}
