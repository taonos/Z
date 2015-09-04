//
//  SocialBusinessWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

private let SocialBusinessViewControllerIdentifier = "SocialBusinessViewController"
private let SocialBusinessStoryboardName = "SocialBusiness"
private let UserProfileViewControllerIdentifier = "UserProfileViewController"
private let UserProfileStoryboardName = "UserProfile"

public final class SocialBusinessWireframe : ISocialBusinessWireframe {
    
    private let userService: IUserService
    private let participationService: IParticipationService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    public weak var sharedNavigationController: UINavigationController?
    
    public required init(userService: IUserService, participationService: IParticipationService, geoLocationService: IGeoLocationService, imageService: IImageService) {
        self.userService = userService
        self.participationService = participationService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
    }
    
    /**
    Inject ViewModel to view controller.
    
    :returns: Properly configured DetailViewController.
    */
    private func injectViewModelToViewController(businessModel: Business) -> SocialBusinessViewController {
        // retrieve view controller from storyboard
        let viewController = UIStoryboard(name: SocialBusinessStoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(SocialBusinessViewControllerIdentifier) as! SocialBusinessViewController

        let socialBusinessViewModel = SocialBusinessViewModel(userService: userService, participationService: participationService, geoLocationService: geoLocationService, imageService: imageService, businessModel: businessModel)
        viewController.bindToViewModel(socialBusinessViewModel)
        
        return viewController
    }
    
    public func viewController(business: Business) -> SocialBusinessViewController {
        return injectViewModelToViewController(business)
    }
}

extension SocialBusinessWireframe : SocialBusinessNavigator {
    public func pushUserProfile(user: User, animated: Bool) {
        let viewController = UIStoryboard(name: UserProfileStoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(UserProfileViewControllerIdentifier) as! UserProfileViewController
        
        let userProfileViewModel = UserProfileViewModel()
        viewController.bindToViewModel(userProfileViewModel)
        
        sharedNavigationController?.pushViewController(viewController, animated: animated)
    }
}