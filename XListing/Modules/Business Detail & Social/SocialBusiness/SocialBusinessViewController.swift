//
//  SocialBusinessViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveArray
import Dollar

private let UserCellIdentifier = "SocialBusiness_UserCell"
private let BusinessCellIdentifier = "SocialBusiness_BusinessCell"
private let userControllerIdentifier = "UserProfileViewController"
private let BusinessHeightRatio = 0.61
private let UserHeightRatio = 0.224
private let ScreenWidth = UIScreen.mainScreen().bounds.size.width
private let WTGBarHeight = CGFloat(70)

public final class SocialBusinessViewController : XUIViewController {
    
    // MARK: - UI Controls
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var infoButton: UIButton!
    @IBOutlet private weak var startEventButton: UIButton!
    
    // MARK: - Properties
    private var viewmodel: ISocialBusinessViewModel!

    // MARK: - Setups
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let businessNib = UINib(nibName: "SocialBusiness_BusinessCell", bundle: nil)
        tableView.registerClass(SocialBusiness_UserCell.self, forCellReuseIdentifier: UserCellIdentifier)
        tableView.registerNib(businessNib, forCellReuseIdentifier: BusinessCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: ISocialBusinessViewModel) {
        self.viewmodel = viewmodel
        
    }
    
    // MARK: - Others
}

extension SocialBusinessViewController: UITableViewDelegate, UITableViewDataSource{
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch(section) {
        case 0: return 1
        case 1: return 10
        default: return 0
        }
    }
    
    public func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
            switch(indexPath.section){
            case 0: var cell = tableView.dequeueReusableCellWithIdentifier(BusinessCellIdentifier) as! SocialBusiness_BusinessCell
                cell.frame = CGRectMake(0, 0, CGFloat(ScreenWidth), CGFloat(ScreenWidth) * CGFloat(BusinessHeightRatio))
                return cell
            default: var cell = tableView.dequeueReusableCellWithIdentifier(UserCellIdentifier) as!
                SocialBusiness_UserCell
                cell.frame = CGRectMake(0, 0, CGFloat(ScreenWidth), CGFloat(ScreenWidth) * CGFloat(UserHeightRatio))
                return cell
            }
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch(indexPath.section) {
        case 0: return CGFloat(ScreenWidth) * CGFloat(BusinessHeightRatio)
        default: return CGFloat(ScreenWidth) * CGFloat(UserHeightRatio)
        }
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 1) {
            let view = UIView(frame: CGRectMake(0, 0, CGFloat(ScreenWidth), WTGBarHeight))
            let bar = NSBundle.mainBundle().loadNibNamed("SocialBusiness_UtilityView", owner: self, options:nil)[0] as? UIView
            bar?.frame = CGRectMake(0, 0, CGFloat(ScreenWidth), WTGBarHeight)
            if let bar = bar{
                view.addSubview(bar)
            }
            return view
        }
        return nil
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        switch(section){
        case 0: return 0
        case 1: return WTGBarHeight
        default: return 0
        }
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        DDLogDebug("cell selected")
        if(indexPath.section == 1){
            let storyboard = UIStoryboard(name: "UserProfile", bundle: nil)
            if let controller = storyboard.instantiateViewControllerWithIdentifier(userControllerIdentifier) as? UserProfileViewController{
                self.presentViewController(controller, animated: true, completion: {})
            }
        }
    }
    
    
}