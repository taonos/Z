//
//  UsernameAndPasswordView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Cartography

public final class UsernameAndPasswordView : UIView {
    
    // MARK: - UI Controls
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    private let _signUpButton = RoundedButton()
    public var signUpButton: RoundedButton {
        return _signUpButton
    }
    
    // MARK: - Properties
    public let viewmodel = MutableProperty<UsernameAndPasswordViewModel?>(nil)
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Proxies
    private let (_submitProxy, _submitSink) = SimpleProxy.proxy()
    public var submitProxy: SimpleProxy {
        return _submitProxy
    }
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        _signUpButton.setTitle("注 册", forState: .Normal)
        
        let submitAction = Action<UIButton, Void, NSError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    proxyNext(this._submitSink, ())
                }
                sendCompleted(sink)
            }
        }
        
        
        // Link UIControl event to actions
        _signUpButton.addTarget(submitAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        
        compositeDisposable += viewmodel.producer
            |> ignoreNil
            |> logLifeCycle(LogContext.Account, "viewmodel.producer")
            |> start(next: { [weak self] viewmodel in
                if let this = self {
                    // bind signals
                    viewmodel.username <~ this.usernameField.rac_text
                    viewmodel.password <~ this.passwordField.rac_text
                    
                    // TODO: implement different validation for different input fields.
                    this._signUpButton.rac_enabled <~ viewmodel.allInputsValid
                }
                
            })
        
        /**
        Setup constraints
        */
        
        /// The below two blocks of code achieve the same thing.

//        // width set to frame width
//        let width = NSLayoutConstraint(
//            item: self,
//            attribute: NSLayoutAttribute.Width,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: nil,
//            attribute: NSLayoutAttribute.NotAnAttribute,
//            multiplier: 1.0,
//            constant: frame.width
//        )
//        width.identifier = "width"
//        
//        // height set to frame height
//        let height = NSLayoutConstraint(
//            item: self,
//            attribute: NSLayoutAttribute.Height,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: nil,
//            attribute: NSLayoutAttribute.NotAnAttribute,
//            multiplier: 1.0,
//            constant: frame.height
//        )
//        height.identifier = "height"
//        
//        addConstraints(
//            [
//                width,
//                height
//            ]
//        )
        
        let group = layout(self) { view in
            view.width == self.frame.width
            view.height == self.frame.height
        }
        
        /**
        Constraints block done.
        */
        
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        
        usernameField.becomeFirstResponder()
    }
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("UsernameAndPasswordView deinitializes.")
    }
    
    // MARK: Bindings
    
    // MARK: Others
}

extension UsernameAndPasswordView : UITextFieldDelegate {
    /**
    The text field calls this method whenever the user taps the return button. You can use this method to implement any custom behavior when the button is tapped.
    
    :param: textField The text field whose return button was pressed.
    
    :returns: YES if the text field should implement its default behavior for the return button; otherwise, NO.
    */
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        if usernameField == textField {
            passwordField.becomeFirstResponder()
        }
        else if passwordField == textField {
            passwordField.resignFirstResponder()
            
            _signUpButton.sendActionsForControlEvents(.TouchUpInside)
        }
        return false
    }
}