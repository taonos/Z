//
//  NicknameView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Cartography

public final class NicknameView : UIView {
    
    // MARK: - UI Controls
    @IBOutlet private weak var nicknameField: UITextField!
    
    // MARK: - Properties
    public let viewmodel = MutableProperty<NicknameViewModel?>(nil)
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Proxies
    private let (_continueProxy, _continueSink) = SimpleProxy.proxy()
    public var continueProxy: SimpleProxy {
        return _continueProxy
    }
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        /**
        Setup constraints
        */
        let group = layout(self) { view in
            view.width == self.frame.width
            view.height == self.frame.height
        }
        
        nicknameField.delegate = self
        nicknameField.becomeFirstResponder()
        
        compositeDisposable += viewmodel.producer
            |> ignoreNil
            |> logLifeCycle(LogContext.Account, "viewmodel.producer")
            |> start(next: { [weak self] viewmodel in
                if let this = self {
                    viewmodel.nickname <~ this.nicknameField.rac_text
                    
                    // TODO: implement different validation for different input fields.
                    //        confirmButton.rac_enabled <~ viewmodel.allInputsValid
                }
            })
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        
        nicknameField.resignFirstResponder()
    }
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("NicknameView deinitializes.")
    }
    
    // MARK: - Bindings
    
    // MARK: - Others
}

extension NicknameView : UITextFieldDelegate {
    /**
    The text field calls this method whenever the user taps the return button. You can use this method to implement any custom behavior when the button is tapped.
    
    :param: textField The text field whose return button was pressed.
    
    :returns: YES if the text field should implement its default behavior for the return button; otherwise, NO.
    */
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == nicknameField {
            nicknameField.resignFirstResponder()
            sendNext(_continueSink, ())
        }
        
        return false
    }
}