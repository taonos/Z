//
//  FeaturedListWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

private let FeaturedListViewControllerIdentifier = "FeaturedListViewController"

public final class FeaturedListWireframe : BaseWireframe, IFeaturedListWireframe {
    
    private let router: IRouter
    private let businessService: IBusinessService
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    
    public required init(rootWireframe: IRootWireframe, router: IRouter, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService) {
        self.router = router
        self.businessService = businessService
        self.userService = userService
        self.geoLocationService = geoLocationService
        self.userDefaultsService = userDefaultsService
        
        super.init(rootWireframe: rootWireframe)
    }
    
    /**
        Inject ViewModel to view controller.
    
        :returns: Properly configured FeaturedListViewController.
    */
    private func initViewController() -> FeaturedListViewController {
        // retrieve view controller from storyboard
        let viewController = getViewControllerFromStoryboard(FeaturedListViewControllerIdentifier) as! FeaturedListViewController
        let viewmodel = FeaturedListViewModel(router: router, businessService: businessService, userService: userService, geoLocationService: geoLocationService, userDefaultsService: userDefaultsService)
        viewController.bindToViewModel(viewmodel)
        
        return viewController
    }
}

extension FeaturedListWireframe : FeaturedRoute {
    public func push() {
        
        let injectedViewController = initViewController()
        rootWireframe.showRootViewController(injectedViewController)
        
    }
}