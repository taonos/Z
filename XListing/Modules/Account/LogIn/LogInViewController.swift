//
//  LogInViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

public final class LogInViewController: XUIViewController {
    
    private var viewmodel: LogInViewModel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    private var loginButtonAction: CocoaAction!
    
    internal var containerVC : ContainerViewController!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUsername()
        setUpPassword()
        setUpLoginButton()
        setUpBackButton()
    }
    
    public func setUpBackButton () {
        backButton.addTarget(self, action: "returnToLanding", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    public func returnToLanding () {
       self.containerVC.switchToLanding()
    }
    
    public func setUpLoginButton () {
        
        let login = Action<Void, User, NoError> {
            return SignalProducer { sink, disposable in
                viewmodel.logIn
            }
        }
        
        // Bridging actions to Objective-C
        loginButtonAction = CocoaAction(login, input: ())
        
        // Link UIControl event to actions
        loginButton.addTarget(loginButtonAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func bindToViewModel(viewmodel: LogInViewModel) {
        self.viewmodel = viewmodel
        
    }
    
    public func setUpUsername() {
        usernameField.delegate = self
        viewmodel.username <~ usernameField.rac_text
    }
    
    public func setUpPassword() {
        passwordField.delegate = self
        viewmodel.password <~ passwordField.rac_text
    }
}

extension LogInViewController : UITextFieldDelegate {
    /**
    The text field calls this method whenever the user taps the return button. You can use this method to implement any custom behavior when the button is tapped.
    
    :param: textField The text field whose return button was pressed.
    
    :returns: YES if the text field should implement its default behavior for the return button; otherwise, NO.
    */
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

