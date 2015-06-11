//
//  AccountWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactKit
import UIKit

private let AccountViewControllerIdentifier = "AccountViewController"
private let AccountStoryboardName = "Account"

public final class AccountWireframe : BaseWireframe, IAccountWireframe {
    
    private let navigator: INavigator
    private let userService: IUserService
    private var accountVC: AccountViewController?
    
    public required init(rootWireframe: IRootWireframe, navigator: INavigator, userService: IUserService) {
        self.navigator = navigator
        self.userService = userService
        
        super.init(rootWireframe: rootWireframe)
        
        navigator.accountModuleNavigationNotificationSignal! ~> { notification -> Void in
            self.presentView()
        }
    }
    
    private func injectViewModelToViewController() -> AccountViewController {
        let viewController = getViewControllerFromStoryboard(AccountViewControllerIdentifier, storyboardName: AccountStoryboardName) as! AccountViewController
        let viewmodel = AccountViewModel(userService: userService)
        viewController.bindToViewModel(viewmodel)
        accountVC = viewController
        return viewController
    }
    
    
    private func presentView() {
        let injectedViewController = injectViewModelToViewController()
        rootWireframe.presentViewController(injectedViewController, animated: true)
    }
}