//
//  ProfileBottomViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import AVOSCloud
import Dollar
import Cartography


public final class ProfileBottomViewController : UIViewController {
    
    // MARK: - UI Controls
    
    private lazy var pageControls: ProfileSegmentControlView = {
        let view = ProfileSegmentControlView(frame: CGRect(origin: CGPointMake(0, 0), size: self.view.frame.size))
        view.backgroundColor = .whiteColor()
        view.opaque = true
        
        return view
    }()
    
    private lazy var pageViewController: ProfilePageViewController = {
        let vc = ProfilePageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        
        
        
        return vc
    }()
    
    // MARK: - Properties
    private var viewmodel: IProfileBottomViewModel! {
        didSet {
            pageViewController.bindToViewModel(viewmodel.profilePageViewModel)
        }
    }
    
    // MARK: - Initializers
    
    // MARK: - Setups
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.opaque = true
        view.backgroundColor = UIColor.grayColor()
        
        view.addSubview(pageControls)
        
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
        
        constrain(pageControls) {
            $0.leading == $0.superview!.leading
            $0.top == $0.superview!.top
            $0.trailing == $0.superview!.trailing
            $0.height == $0.superview!.height * 0.10
        }
        
        constrain(pageControls, pageViewController.view) {
            $1.leading == $1.superview!.leading
            $1.top == $0.bottom
            $1.trailing == $1.superview!.trailing
            $1.bottom == $1.superview!.bottom
        }
        
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // default starting page
        pageViewController.displayParticipationListPage()
        
        pageControls.participationListProxy
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.Profile, "pageControls.participationListProxy")
            |> start(next: { [weak self] in
                self?.pageViewController.displayParticipationListPage()
            })
        
        pageControls.photosManagerProxy
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.Profile, "pageControls.photosManagerProxy")
            |> start(next: { [weak self] in
                self?.pageViewController.displayPhotosManagerPage()
            })
        
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: IProfileBottomViewModel) {
        self.viewmodel = viewmodel
    }
}