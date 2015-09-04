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
private let BusinessHeightRatio = 0.6
private let UserHeightRatio = 0.25
private let ScreenWidth = UIScreen.mainScreen().bounds.size.width
private let WTGBarHeight = CGFloat(70)

public final class SocialBusinessViewController : UIViewController {
    
    // MARK: - UI Controls
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var infoButton: UIButton!
    @IBOutlet private weak var startEventButton: UIButton!
    
    // MARK: - Properties
    private var viewmodel: ISocialBusinessViewModel!
    
    // MARK: - Setups
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let userNib = UINib(nibName: "SocialBusiness_UserCell", bundle: nil)
        let businessNib = UINib(nibName: "SocialBusiness_BusinessCell", bundle: nil)
        tableView.registerNib(userNib, forCellReuseIdentifier: UserCellIdentifier)
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
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var view: UIView?
        if section == 0 {
            view = NSBundle.mainBundle().loadNibNamed("WTGBar", owner: self, options: nil)[0] as? UIView
            view?.frame = CGRectMake(0, 0, CGFloat(ScreenWidth), WTGBarHeight)
        }
        return view
    }
        
}