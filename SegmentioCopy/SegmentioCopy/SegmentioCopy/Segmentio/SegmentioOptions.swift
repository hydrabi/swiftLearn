//
//  SegmentioOptions.swift
//  SegmentioCopy
//
//  Created by Hydra on 2019/11/2.
//  Copyright © 2019 毕志锋. All rights reserved.
//

import UIKit


public struct SegmentioItem {
    public var title : String?
    public var image : UIImage?
    public var selectedImage : UIImage?
    public var badgeCount : Int?
    public var badgeColor : UIColor?
    public var intrinsicWidth : CGFloat {
        let label = UILabel()
        label.text = self.title
        label.sizeToFit()
        return label.intrinsicContentSize.width
    }
    
    public init(title:String?,image:UIImage?,selectedImage:UIImage?=nil){
        self.title = title
        self.image = image
        self.selectedImage = selectedImage ?? image
    }
    
    //struct 一般用于定义一些纯数据类型，如果在方法里需要更改struct中的变量值那么必须加上 mutating 关键字，默认struct 出来的变量是Immutable.
    public mutating func addBadge(count:Int,color:UIColor){
        self.badgeCount = count
        self.badgeColor = color
    }
    
    public mutating func removeBadge() {
        self.badgeCount = nil
        self.badgeColor = nil
    }
}

public struct SegmentioState {
    var backgroundColor:UIColor
    var titleFont:UIFont
    var titleTextColor:UIColor
    
    public init(backgroundColor:UIColor = .clear,
                titleFont:UIFont = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor:UIColor = .black){
        self.backgroundColor = backgroundColor
        self.titleFont = titleFont
        self.titleTextColor = titleTextColor
    }
}

public enum SegmentioHorizontalSeparatorType {
    case none
    case top
    case bottom
    case topAndBottom
}

public struct SegmentioHorizontalSeparatorOptions {
    var type:SegmentioHorizontalSeparatorType
    var height : CGFloat
    var color : UIColor
    
    public init(type:SegmentioHorizontalSeparatorType = .topAndBottom,
                height:CGFloat = 1.0,
                color:UIColor = .darkGray){
        self.type = type
        self.height = height
        self.color = color
    }
}

public struct SegmentioVerticalSeparatorOptions {
    var ratio:CGFloat
    var color:UIColor
    public init(ratio:CGFloat = 1,color:UIColor = .darkGray){
        self.ratio = ratio
        self.color = color
    }
}

// MARK: - Indicator

public enum SegmentioIndicatorType {
    case top
    case bottom
}

public struct SegmentioIndicatorOptions {
    var type : SegmentioIndicatorType
    var ratio : CGFloat
    var height : CGFloat
    var color : UIColor
    
    public init(type:SegmentioIndicatorType = .bottom,
                ratio:CGFloat = 1,
                height:CGFloat = 2,
                color:UIColor = .orange){
        self.type = type
        self.ratio = ratio
        self.height = height
        self.color = color
    }
}

// MARK: - Position
public enum SegmentioPosition {
    case dynamic
    case fixed(maxVisibleItems:Int)
}

// MARK: - Control options
public enum SegmentioStyle : String {
    case onlyLabel, onlyImage, imageOverLabel, imageUnderLabel,imageBeforeLabel,imageAfterLabel
    
    public static let allStyles = [
        onlyLabel,
        onlyImage,
        imageOverLabel,
        imageUnderLabel,
        imageBeforeLabel,
        imageAfterLabel
    ]
    
    public func isWithText() -> Bool {
        switch self {
        case .onlyLabel,.imageOverLabel,.imageUnderLabel,.imageBeforeLabel,.imageAfterLabel:
            return true
        default:
            return false
        }
    }
    
    public func isWithImage() -> Bool {
        switch self {
        case .imageOverLabel,.imageUnderLabel,.imageBeforeLabel,.imageAfterLabel,.onlyImage:
            return true
        default:
            return false
        }
    }
    
    public var layoutMargins : CGFloat {
        let defaultLayoutMargins : CGFloat = 8.0
        switch self {
        case .onlyLabel,.imageAfterLabel,.imageBeforeLabel,.imageOverLabel,.imageUnderLabel:
            return 4 * defaultLayoutMargins
        default:
            return 2 * defaultLayoutMargins
        }
    }
}

public typealias segmentioStates = (defaultState:SegmentioState,selectedState:SegmentioState,highlightedState:SegmentioState)

public struct SegmentioOptions {
    var backgroundColor : UIColor
    var segmentPosition : SegmentioPosition
    var scrolEnabled : Bool
    var horizontalSeparatorOptions : SegmentioHorizontalSeparatorOptions?
    var verticalSeparatorOptions : SegmentioVerticalSeparatorOptions?
    var indicatorOptions : SegmentioIndicatorOptions?
    var imageContentMode : UIView.ContentMode
    var labelTextAligment : NSTextAlignment
    var labelTextNumberOfLines : Int
    var states : segmentioStates
    var animationDuration : CFTimeInterval
    
    public init() {
        self.backgroundColor = .lightGray
        self.segmentPosition = .fixed(maxVisibleItems: 4)
        self.scrolEnabled = true
        self.indicatorOptions = SegmentioIndicatorOptions()
        self.horizontalSeparatorOptions = SegmentioHorizontalSeparatorOptions()
        self.verticalSeparatorOptions = SegmentioVerticalSeparatorOptions()
    }
}
