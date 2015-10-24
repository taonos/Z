//
//  SocialBusiness_UtilityHeaderView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-11.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveArray
import Dollar
import Cartography

public final class SocialBusiness_UtilityHeaderView : UIView {
    
    // MARK: - UI Controls
    private lazy var detailInfoButton: UIButton = {
        let button = UIButton()
        
        button.titleLabel?.opaque = true
        button.titleLabel?.backgroundColor = .whiteColor()
        button.titleLabel?.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        button.setTitle("详细信息", forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.backgroundColor = .whiteColor()
        button.layer.cornerRadius = 5
        
        let press = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    proxyNext(this._detailInfoSink, ())
                }
                sendCompleted(sink)
            }
        }
        
        button.addTarget(press.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
    private lazy var startEventButton: UIButton = {
        let button = UIButton()
        
        button.titleLabel?.opaque = true
        button.titleLabel?.backgroundColor = .whiteColor()
        button.titleLabel?.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        button.setTitle("约起", forState: .Normal)
        button.setTitleColor(UIColor.x_PrimaryColor(), forState: .Normal)
        button.backgroundColor = .whiteColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.x_PrimaryColor().CGColor
        
        let press = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    proxyNext(this._startEventSink, ())
                }
                sendCompleted(sink)
                
            }
        }
        
        button.addTarget(press.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
    // MARK: - Proxies
    private let (_detailInfoProxy, _detailInfoSink) = SimpleProxy.proxy()
    public var detailInfoProxy: SimpleProxy {
        return _detailInfoProxy
    }
    
    private let (_startEventProxy, _startEventSink) = SimpleProxy.proxy()
    public var startEventProxy: SimpleProxy {
        return _startEventProxy
    }
    
    // MARK: - Properties
    
    // MARK: - Initializers
    public init() {
        super.init(frame: CGRectMake(0, 0, 0, 0))
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    // set the button style to have a grey background and an x icon
    public func setDetailInfoButtonStyleSelected() {
        detailInfoButton.backgroundColor = UIColor.grayColor()
        detailInfoButton.titleLabel?.backgroundColor = UIColor.grayColor()
        detailInfoButton.titleLabel?.textColor = UIColor.whiteColor()
        let xAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "FontAwesome", size: 18)!]
        var xAttributedString = NSAttributedString(string: Icons.X, attributes: xAttributes)
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(18)]
        var attributedString = NSMutableAttributedString(string: "详细信息 ", attributes: attributes)
        attributedString.appendAttributedString(xAttributedString)
        detailInfoButton.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        
    }
    
    // restore the button style to default white background and no x
    public func setDetailInfoButtonStyleRegular() {
        detailInfoButton.backgroundColor = UIColor.whiteColor()
        detailInfoButton.titleLabel?.backgroundColor = UIColor.whiteColor()
        detailInfoButton.titleLabel?.textColor = UIColor.blackColor()
        let attributes = [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(18)]
        var attributedString = NSMutableAttributedString(string: "详细信息", attributes: attributes)
        detailInfoButton.setAttributedTitle(attributedString, forState: .Normal)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    private func setup() {
        backgroundColor = .whiteColor()
        opaque = true
        
        addSubview(detailInfoButton)
        addSubview(startEventButton)
        
        constrain(detailInfoButton) { view in
            view.top == view.superview!.top+12
            view.bottom == view.superview!.bottom-12
            view.leading == view.superview!.leadingMargin + 48
            view.width == 110
        }
        
        constrain(startEventButton) { view in
            view.top == view.superview!.top+12
            view.bottom == view.superview!.bottom-12
            view.trailing == view.superview!.trailingMargin - 16
            view.width == 90
        }
    }
}