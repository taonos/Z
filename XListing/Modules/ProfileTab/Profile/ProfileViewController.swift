//
// Created by Lance Zhu on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import AVOSCloud
import Dollar
import Cartography

private let BusinessCellIdentifier = "BusinessCell"
private let HeaderViewHeightRatio = CGFloat(0.30)

public final class ProfileViewController : XUIViewController {

    // MARK: - UI Controls
    
    private lazy var upperViewController: ProfileUpperViewController = {
        let vc = ProfileUpperViewController()
        
        let selfFrame = self.view.frame
        let viewHeight = round(selfFrame.size.height * 0.30)
        vc.view.frame = CGRect(origin: selfFrame.origin, size: CGSizeMake(selfFrame.size.width, viewHeight))
        
        return vc
    }()
    
    private lazy var bottomViewController: ProfileBottomViewController = {
        let vc = ProfileBottomViewController()
        
        let selfFrame = self.view.frame
        let viewHeight = round(selfFrame.size.height * 0.30)
        vc.view.frame = CGRect(origin: CGPointMake(selfFrame.origin.x, viewHeight), size: CGSizeMake(selfFrame.size.width, selfFrame.size.height - viewHeight))
        
        return vc
    }()
    
    private lazy var pageViewController: ProfilePageViewController = {
        let vc = ProfilePageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        
        
        
        return vc
    }()
    
    // MARK: - Properties
    private var viewmodel: IProfileViewModel! {
        didSet {
            upperViewController.bindToViewModel(viewmodel.profileUpperViewModel)
        }
    }
    private let compositeDisposable = CompositeDisposable()

    // MARK: - Setups
    public override func loadView() {
        super.loadView()
//        
//        let nib = UINib(nibName: "ProfileBusinessCell", bundle: nil)
//        tableView.registerNib(nib, forCellReuseIdentifier: BusinessCellIdentifier)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.opaque = true
        view.backgroundColor = UIColor.grayColor()
        
        navigationController?.navigationBarHidden = true
        navigationItem.title = "个人"
        
        
//        tableView.rowHeight = 90
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        addChildViewController(upperViewController)
        addChildViewController(bottomViewController)
        
        view.addSubview(upperViewController.view)
        view.addSubview(bottomViewController.view)
        
        upperViewController.didMoveToParentViewController(self)
        bottomViewController.didMoveToParentViewController(self)
        
        constrain(upperViewController.view) {
            $0.leading == $0.superview!.leading
            $0.top == $0.superview!.top
            $0.trailing == $0.superview!.trailing
            $0.height == $0.superview!.height * 0.30
        }
        
        constrain(upperViewController.view, bottomViewController.view) {
            $1.leading == $1.superview!.leading
            $1.top == $0.bottom
            $1.trailing == $1.superview!.trailing
            $1.bottom == $1.superview!.bottom
        }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.hidesBarsOnSwipe = false
//
//        willAppearTableView()
//        
//        compositeDisposable += headerViewContent.editProxy
//            // forwards events from producer until the view controller is going to disappear
//            |> takeUntilViewWillDisappear(self)
//            |> logLifeCycle(LogContext.Profile, "headerViewContent.editProxy")
//            |> start(
//                next: { [weak self] in
//                    self?.viewmodel.presentProfileEditModule(true, completion: nil)
//                }
//            )
        
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func willAppearTableView() {
        
//        // create a signal associated with `tableView:didSelectRowAtIndexPath:` form delegate `UITableViewDelegate`
//        // when the specified row is now selected
//        compositeDisposable += rac_signalForSelector(Selector("tableView:didSelectRowAtIndexPath:"), fromProtocol: UITableViewDelegate.self).toSignalProducer()
//            // forwards events from producer until the view controller is going to disappear
//            |> takeUntilViewWillDisappear(self)
//            |> map { ($0 as! RACTuple).second as! NSIndexPath }
//            |> logLifeCycle(LogContext.Profile, "tableView:didSelectRowAtIndexPath:")
//            |> start(
//                next: { [weak self] indexPath in
//                    self?.viewmodel.pushSocialBusinessModule(indexPath.row, animated: true)
//                }
//            )
//        
//        compositeDisposable += rac_signalForSelector(Selector("tableView:commitEditingStyle:forRowAtIndexPath:"), fromProtocol: UITableViewDataSource.self).toSignalProducer()
//            // forwards events from producer until the view controller is going to disappear
//            |> takeUntilViewWillDisappear(self)
//            |> map { parameters -> (UITableViewCellEditingStyle, NSIndexPath) in
//                let tuple = parameters as! RACTuple
//                return (tuple.second as! UITableViewCellEditingStyle, tuple.third as! NSIndexPath)
//            }
//            |> logLifeCycle(LogContext.Profile, "tableView:commitEditingStyle:forRowAtIndexPath:")
//            |> start(
//                next: { [weak self] editingStyle, indexPath in
//                    if let this = self {
//                        if editingStyle == UITableViewCellEditingStyle.Delete {
//                            this.viewmodel.undoParticipation(indexPath.row)
//                                |> start()
//                            this.viewmodel.profileBusinessViewModelArr.value.removeAtIndex(indexPath.row)
//                            this.tableView.reloadData()
//                        }
//                    }
//                }
//            )
//        
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        viewmodel.profileBusinessViewModelArr.producer
//            |> start(next: { [weak self] _ in
//                self?.tableView.reloadData()
//            })
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(profileViewModel: IProfileViewModel) {
        viewmodel = profileViewModel
        
//        viewmodel.profileHeaderViewModel.producer
//            |> ignoreNil
//            |> start(next: headerView.bindToViewModel )
    }
    
    // MARK: - Others
}


/**
*  UITableViewDataSource
*/
extension ProfileViewController : UITableViewDataSource, UITableViewDelegate {
    /**
    Asks the data source to return the number of sections in the table view.
    
    :param: tableView An object representing the table view requesting this information.
    
    :returns: The number of sections in tableView. The default value is 1.
    */
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    :param: tableView The table-view object requesting this information.
    :param: section   An index number identifying a section in tableView.
    
    :returns: The number of rows in section.
    */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return numberOfChats
        return viewmodel.profileBusinessViewModelArr.value.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var businessCell = tableView.dequeueReusableCellWithIdentifier(BusinessCellIdentifier, forIndexPath: indexPath) as! ProfileBusinessCell
        businessCell.bindViewModel(viewmodel.profileBusinessViewModelArr.value[indexPath.row])
        
        return businessCell
        
    }
}

/**
*  UITableViewDelegate
*/
extension ProfileViewController : UITableViewDelegate {
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
}