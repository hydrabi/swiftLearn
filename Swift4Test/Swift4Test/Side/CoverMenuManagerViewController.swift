//
//  SideMenuManagerViewController.swift
//  Swift4Test
//
//  Created by Hydra on 2019/6/24.
//  Copyright © 2019 毕志锋. All rights reserved.
//

import UIKit

class CoverMenuManagerViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var visibleMenuWidth:CGFloat = UIScreen.main.bounds.size.width - 60
    
    
    var hadShow:Bool = false
    let kScreenshotImageOriginalLeft:CGFloat = -150.0
    let mainMaskViewMaxAlpha:CGFloat = 0.3
    weak var parentVC:UIViewController?

    //开始滑动的起点
    var startTouchPointInMainVC:CGPoint = CGPoint.init()
    var moving:Bool = false
    
    var delegates:NSHashTable<AnyObject> = NSHashTable.weakObjects()
    
    var blackMaskView:UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.backgroundColor = .black
        return view
    }()
    
    var mainMaskView:UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    var canDragMenu:Bool = true {
        didSet {
            let pan = UIPanGestureRecognizer.init(target: self, action: #selector(paningGestureReceive(sender:)))
            
            if(self.canDragMenu){
                self.mainViewController.view.addGestureRecognizer(pan)
            }
            else{
                self.mainViewController.view.removeGestureRecognizer(pan)
            }
        }
    }
    
    var mainViewController:UIViewController {
        willSet {
            self.mainViewController.removeFromParentViewController()
            self.mainViewController.view.removeFromSuperview()
        }
        
        didSet {
            self.addChildViewController(self.mainViewController)
            self.mainViewController.view.frame = self.view.bounds
            self.view.insertSubview(self.mainViewController.view,
                                    aboveSubview: self.blackMaskView)
            let can = self.canDragMenu
            self.canDragMenu = can
        }
    }
    
    var menuViewController:UIViewController {
        willSet {
            self.menuViewController.removeFromParentViewController()
            self.menuViewController.view.removeFromSuperview()
        }
        
        didSet {
            self.addChildViewController(self.menuViewController)
            self.menuViewController.view.frame = self.view.bounds
            self.view.insertSubview(self.menuViewController.view, belowSubview: self.blackMaskView)
        }
    }
    
    required init(menuViewController:UIViewController,parentVC:UIViewController){
        self.parentVC = parentVC
        let main = UIViewController.init()
        main.view.backgroundColor = .clear
        self.mainViewController = main
        self.menuViewController = menuViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configUI()
    }
    
    func configUI () {
        self.addChildViewController(self.menuViewController)
        self.addChildViewController(self.mainViewController)
        
        var rect = self.view.bounds
        rect.size.width = UIScreen.main.bounds.size.width - 60
        self.menuViewController.view.frame = rect
        self.mainViewController.view.frame = self.view.bounds
        
        self.view.addSubview(self.menuViewController.view)
        self.view.addSubview(self.mainViewController.view)
        
        self.view.insertSubview(self.blackMaskView, belowSubview: self.mainViewController.view)
        self.blackMaskView.frame = self.view.bounds
        
        self.mainMaskView.frame = self.view.bounds;
        self.mainMaskView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureReceive(sender:)))
        self.mainMaskView.addGestureRecognizer(tap)
        
        self.canDragMenu = true
    }
    
    func moveView(x:CGFloat) {
        var moveX = min(x, self.visibleMenuWidth)
        moveX = max(moveX, 0)
        
        var frame = self.mainViewController.view.frame
        frame.origin.x = moveX
        self.mainViewController.view.frame = frame
        
        let alpha = (1.0 - moveX/self.visibleMenuWidth) / 2.0
        self.blackMaskView.alpha = alpha
        
        if self.mainMaskView.superview == nil {
            self.mainViewController.view.addSubview(self.mainMaskView)
        }
        
        let mainAlpha = mainMaskViewMaxAlpha * (moveX - self.visibleMenuWidth) / self.visibleMenuWidth + mainMaskViewMaxAlpha
        self.mainMaskView.alpha = mainAlpha
        
        let rect = self.menuViewController.view.frame
        
        self.menuViewController.view.frame = CGRect.init(x: moveX - visibleMenuWidth ,
                                                         y: 0,
                                                         width: rect.size.width,
                                                         height: rect.size.height)
    }
    
    deinit {
        self.mainViewController.removeFromParentViewController()
        self.menuViewController.removeFromParentViewController()
        
        self.mainViewController.view.removeFromSuperview()
        self.menuViewController.view.removeFromSuperview()
    }
    
    //MARK:SideMenuManagerViewController Methods
    func presentMenuViewController() {
        
        self.parentVC?.addChildViewController(self)
        self.parentVC?.view.addSubview(self.view)
        self.didMove(toParentViewController: self.parentVC)
        
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.moveView(x: self.visibleMenuWidth)
        }) { (finish) in
            self.sendMenuDidAppearNotification()
        }
    }
    
    func dismissMenuViewController() {
        
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.moveView(x: 0)
        }) { (finish) in
            self.sendMenuDidDisappearNotification()
        }
    }
    
    func sendMenuDidAppearNotification() {
        self.hadShow = true
        for del in self.delegates.setRepresentation {
            if let delegate = del as? SideMenuManagerViewControllerDelegate {
                delegate.menuDidAppear()
            }
        }
    }
    
    func sendMenuDidDisappearNotification () {
        self.hadShow = false
        self.mainMaskView.removeFromSuperview()
        
        for del in self.delegates.setRepresentation {
            if let delegate = del as? SideMenuManagerViewControllerDelegate {
                delegate.menuDidDisappear()
            }
        }
        
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    //MARK: Delegates Methods
    func bind(delegate:SideMenuManagerViewControllerDelegate) {
        if !self.delegates.contains(delegate as AnyObject) {
            self.delegates.add(delegate as AnyObject)
        }
    }
    
    func unbind(delegate:SideMenuManagerViewControllerDelegate) {
        if self.delegates.contains(delegate as AnyObject) {
            self.delegates.remove(delegate as AnyObject)
        }
    }
    
    //MARK:Gesture Recognizer Methods
    @objc func paningGestureReceive(sender:UIPanGestureRecognizer){
        switch sender.state {
        case .began:
            self._panGestureRecognizerBegan(sender: sender)
        case .changed:
            self._panGestureRecognizerChanged(sender: sender)
        case .ended:
            self._panGestureRecognizerEnded(sender: sender)
        case .cancelled:
            self._panGestureRecognizerCancelled(sender: sender)
        default:
            print("")
        }
    }
    
    @objc func tapGestureReceive(sender:UITapGestureRecognizer){
        switch sender.state {
        case .ended:
            self.dismissMenuViewController()
        default:
            ()
        }
    }
    
    func _panGestureRecognizerBegan(sender:UIPanGestureRecognizer) {
        self.moving = true
        self.startTouchPointInMainVC = sender.location(in: self.mainViewController.view)
    }
    
    func _panGestureRecognizerChanged(sender:UIPanGestureRecognizer) {
        let keywindow = UIApplication.shared.keyWindow
        let touchPointInWindow = sender.location(in: keywindow)
        if (self.moving){
            self.moveView(x: touchPointInWindow.x - self.startTouchPointInMainVC.x)
        }
    }
    
    func _panGestureRecognizerEnded(sender:UIPanGestureRecognizer) {
        let touchPointInWindow = sender.location(in: UIApplication.shared.keyWindow)
        if (touchPointInWindow.x - self.startTouchPointInMainVC.x > self.visibleMenuWidth / 2.0) {
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.moveView(x: self.visibleMenuWidth)
            }) { (finish) in
                self.moving = false
                self.sendMenuDidAppearNotification()
            }
        }
        else {
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.moveView(x: 0)
            }) { (finish) in
                self.moving = false
                self.sendMenuDidDisappearNotification()
            }
        }
    }
    
    func _panGestureRecognizerCancelled(sender:UIPanGestureRecognizer) {
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.moveView(x: 0)
        }) { (finish) in
            self.moving = false
            self.sendMenuDidDisappearNotification()
        }
    }
}
