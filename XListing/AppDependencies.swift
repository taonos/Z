//
//  AppDependencies.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

/**
    Dependency injector.
*/
public struct AppDependencies {
    
    private var featuredListWireframe: IFeaturedListWireframe?
    private var nearbyWireframe: INearbyWireframe?
    private var detailWireframe: IDetailWireframe?
    private var accountWireframe: IAccountWireframe?
    private var profileWireframe: IProfileWireframe?
    private var wantToGoListWireframe: IWantToGoListWireframe?
    
    private let router: Router = Router.sharedInstance
    private let gs: IGeoLocationService = GeoLocationService()
    private let bs: IBusinessService = BusinessService()
    private let ps: IParticipationService = ParticipationService()
    private let ks: IKeychainService = KeychainService()
    private let userService: IUserService = UserService()
    private let userDefaultsService: IUserDefaultsService = UserDefaultsService()
    
    public init(window: UIWindow) {
        // init HUD
        HUD.sharedInstance

        let rootWireframe: IRootWireframe = RootWireframe(inWindow: window)
        
        configureAccountDependencies(rootWireframe, router: router, userService: userService, userDefaultsService: userDefaultsService)
        configureFeaturedListDependencies(rootWireframe, router: router, businessService: bs, userService: userService, geoLocationService: gs, userDefaultsService: userDefaultsService)
        configureNearbyDependencies(rootWireframe, router: router, businessService: bs, geoLocationService: gs)
        configureDetailDependencies(rootWireframe, router: router, userService: userService, participationService: ps, geoLocationService: gs)
        configureProfileDependencies(rootWireframe, router: router, userService: userService)
        configureWantToGoListDependencies(rootWireframe, router: router, userService: userService, participationService: ps)
    }
    
    /**
        Install the root view controller to the window for display.
    
        :param: window The UIWindow that needs to have a root view installed.
    */
    public func installRootViewControllerIntoWindow() {
        if !userDefaultsService.accountModuleSkipped && !userService.isLoggedInAlready() {
            router.pushAccount()
        }
        else {
            router.pushFeatured()
        }
    }
    
    /**
        Configure dependencies for FeaturedList Module.

        :param: rootWireframe The RootWireframe.
    */
    private mutating func configureFeaturedListDependencies(rootWireframe: IRootWireframe, router: IRouter, businessService bs: IBusinessService, userService us: IUserService, geoLocationService gs: IGeoLocationService, userDefaultsService uds: IUserDefaultsService) {
        
        featuredListWireframe = FeaturedListWireframe(rootWireframe: rootWireframe, router: router, businessService: bs, userService: us, geoLocationService: gs, userDefaultsService: uds)
        self.router.featuredRouteDelegate = featuredListWireframe as! FeaturedRoute
    }
    
    /**
    Configure dependencies for Nearby Module.
    
    :param: rootWireframe The RootWireframe.
    */
    private mutating func configureNearbyDependencies(rootWireframe: IRootWireframe, router: IRouter, businessService bs: IBusinessService, geoLocationService gs: IGeoLocationService) {
        
        nearbyWireframe = NearbyWireframe(rootWireframe: rootWireframe, router: router, businessService: bs, geoLocationService: gs)
        self.router.nearbyRouteDelegate = nearbyWireframe as! NearbyRoute
    }
    
    /**
    Configure dependencies for Detail Module.
    
    :param: rootWireframe The RootWireframe.
    */
    private mutating func configureDetailDependencies(rootWireframe: IRootWireframe, router: IRouter, userService us: IUserService, participationService ps: IParticipationService, geoLocationService gs: IGeoLocationService) {
        
        detailWireframe = DetailWireframe(rootWireframe: rootWireframe, router: router, userService: us, participationService: ps, geoLocationService: gs)
        self.router.detailRouteDelegate = detailWireframe as! DetailRoute
    }
    
    private mutating func configureAccountDependencies(rootWireframe: IRootWireframe, router: IRouter, userService us: IUserService, userDefaultsService uds: IUserDefaultsService) {
        
        accountWireframe = AccountWireframe(rootWireframe: rootWireframe, router: router, userService: us, userDefaultsService: uds)
        self.router.accountRouteDelegate = accountWireframe as! AccountRoute
    }

    private mutating func configureProfileDependencies(rootWireframe: IRootWireframe, router: IRouter, userService us: IUserService) {

        profileWireframe = ProfileWireframe(rootWireframe: rootWireframe, router: router, userService: us)
        self.router.profileRouteDelegate = profileWireframe as! ProfileRoute
    }
    
    private mutating func configureWantToGoListDependencies(rootWireframe: IRootWireframe, router: IRouter, userService us: IUserService, participationService ps: IParticipationService) {
        
        wantToGoListWireframe = WantToGoListWireframe(rootWireframe: rootWireframe, router: router, userService: us, participationService: ps)
        self.router.wantToGoListRouteDelegate = wantToGoListWireframe as! WantToGoRoute
    }
}
