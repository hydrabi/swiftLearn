//
//  Segmentio.swift
//  SegmentioCopy
//
//  Created by Hydra on 2019/11/1.
//  Copyright © 2019 毕志锋. All rights reserved.
//

import UIKit
import QuartzCore

//typealias:用来为已存在的类型重新定义名称的.
public typealias SegmentioSelectionCallback = (_ segmentio:Segmentio,_ selectIndex:Int) -> Void

//1、private
//private访问级别所修饰的属性或者方法只能在当前类里访问。
//
//2、fileprivate
//fileprivate访问级别所修饰的属性或者方法在当前的Swift源文件里可以访问。
//
//3、internal（默认访问级别，internal修饰符可写可不写）
//internal访问级别所修饰的属性或方法在源代码所在的整个模块都可以访问。
//如果是框架或者库代码，则在整个框架内部都可以访问，框架由外部代码所引用时，则不可以访问。
//如果是App代码，也是在整个App代码，也是在整个App内部可以访问。
//
//4、public
//可以被任何人访问。但其他module中不可以被override和继承，而在module内可以被override和继承。
//
//5，open
//可以被任何人使用，包括override和继承。

open class Segmentio: UIView {

    internal struct Points {
        var startPoint : CGPoint
        var endPoint : CGPoint
    }
    
    internal struct ItemInSuperview {
        var collectionViewWidth : CGFloat
        var cellFrameInSuperview : CGRect
        var shapeLayerWidth : CGFloat
        var startX : CGFloat
        var endX : CGFloat
    }

    open var valueDidChange : SegmentioSelectionCallback?
    open var selectedSegmentioIndex = -1 {
        didSet {
            if selectedSegmentioIndex != oldValue {
//                reloadSegmentio()
                //触发回调
                valueDidChange?(self,selectedSegmentioIndex)
            }
        }
    }
    
    open private var segmentioItems = [segmentioItem]()
    private var setmentioCollectionView : UICollectionView?
//    private var segmentioOptions = segmentio
}
