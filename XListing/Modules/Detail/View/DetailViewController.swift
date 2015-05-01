//
//  DetailViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit
import Realm
import MapKit
import WebKit

private let CityDistanceSeparator = " • "

public class DetailViewController : UIViewController {
    
    public var detailVM: IDetailViewModel?
    
    public var businessVM: BusinessViewModel?
    
    public var mapView = MKMapView?()
    
    public var expandHours: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
  
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.allowsSelection = false
        
        self.navigationItem.title = businessVM?.nameSChinese
        println(businessVM!)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public override func viewDidDisappear(animated: Bool) {
        
      
//        mapView?.removeFromSuperview()
//        mapView = nil
    
    }
    
    public func wantToGoPopover(){
        
        var alert = UIAlertController(title: "什么时候想去？", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "这个星期", style: UIAlertActionStyle.Default) { alert in
            detailVM?.goingToBusiness(businessVM!, thisWeek: true, thisMonth: false, later: false)
            })
            
            
        alert.addAction(UIAlertAction(title: "这个月", style: UIAlertActionStyle.Default) { alert in
            detailVM?.goingToBusiness(businessVM!, thisWeek: false, thisMonth: true, later: false)
            })
        
        alert.addAction(UIAlertAction(title: "以后", style: UIAlertActionStyle.Default) { alert in
            detailVM?.goingToBusiness(businessVM!, thisWeek: false, thisMonth: false, later: true)
            })
        
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
     
        
    }
    
    public func shareSheetAction() {
        var someText = "blah"
        let google:NSURL = NSURL(string:"http://google.com/")!
        
        let activityViewController = UIActivityViewController(
            activityItems: [someText, google],
            applicationActivities:nil)
        self.presentViewController(activityViewController,
            animated: true,
            completion: nil)
        
    }
    
    public func callBusiness(){
//        NSString *phoneNumber = [@"tel://" stringByAppendingString:mymobileNO.titleLabel.text];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        
        var phoneNumber = "tel:"+businessVM!.phone!
        UIApplication.sharedApplication().openURL(NSURL (string: phoneNumber)!)
    }
    
    public func goToWebsiteUrl(){
        
       
        
        let webVC = UIViewController()
        var webView = WKWebView()
        var url = NSURL(string:businessVM!.url!)
        var req = NSURLRequest(URL:url!)
        webView.loadRequest(req)
        webVC.view = webView
        
        let navController = UINavigationController()

        navController.pushViewController(webVC, animated: true)
     
        webVC.navigationItem.title = businessVM?.nameSChinese
        webVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "dismissWebView")
        self.presentViewController(navController, animated: true, completion: nil)

    }
    
    public func dismissWebView() {
        
        self.presentedViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    
    
}

/**
*  UITableViewDataSource
*/
extension DetailViewController : UITableViewDataSource {
    /**
    Asks the data source to return the number of sections in the table view.
    
    :param: tableView An object representing the table view requesting this information.
    
    :returns: The number of sections in tableView. The default value is 1.
    */
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    :param: tableView The table-view object requesting this information.
    :param: section   An index number identifying a section in tableView.
    
    :returns: The number of rows in section.
    */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 3
        case 1: return 2
        case 2: return 2
        case 3: return 4
        default: return 1
        }
        
    }
    
    /**
    Asks the data source for a cell to insert in a particular location of the table view. (required)
    
    :param: tableView A table-view object requesting the cell.
    :param: indexPath An index path locating a row in tableView.
    
    :returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil
    */
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let row = indexPath.row
        let section = indexPath.section
        
        
        
        switch (section){
        
        case 0:
            switch (row){
            case 0:
                var cell0 = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! UITableViewCell
                
                cell0.layoutMargins = UIEdgeInsetsZero;
                cell0.preservesSuperviewLayoutMargins = false;
                
                let businessImageView = self.view.viewWithTag(1) as? UIImageView
                
                businessImageView!.hnk_setImageFromURL(NSURL(string: businessVM!.coverImageUrl!)!, failure: {
                    println("Image loading failed: \($0)")
                })
                
                return cell0
                
            case 1:
                var cell1 = tableView.dequeueReusableCellWithIdentifier("BizInfoCell", forIndexPath: indexPath) as! UITableViewCell
                
                cell1.layoutMargins = UIEdgeInsetsZero;
                cell1.preservesSuperviewLayoutMargins = false;
                
                var businessNameLabel : UILabel? = self.view.viewWithTag(1) as? UILabel
                var cityLabel : UILabel? = self.view.viewWithTag(2) as? UILabel
                var distanceLabel : UILabel? = self.view.viewWithTag(3) as? UILabel
                
                businessNameLabel?.text = businessVM?.nameSChinese
                var distance: String
                if let d = businessVM?.distance {
                    distance = CityDistanceSeparator + d
                }
                else {
                    distance = ""
                }
                var city = businessVM!.city!
                cityLabel?.text = city + distance
                //distanceLabel?.text = businessVM?.distance
                
                return cell1
                
                
            case 2:
                var cell2 = tableView.dequeueReusableCellWithIdentifier("ButtonCell", forIndexPath: indexPath) as! UITableViewCell
                
                cell2.layoutMargins = UIEdgeInsetsZero;
                cell2.preservesSuperviewLayoutMargins = false;
                
                var wantToGoButton : UIButton? = self.view.viewWithTag(1) as? UIButton
                var shareButton : UIButton? = self.view.viewWithTag(2) as? UIButton
                
                wantToGoButton?.addTarget(self, action: "wantToGoPopover", forControlEvents: .TouchUpInside)
                shareButton?.addTarget(self, action: "shareSheetAction", forControlEvents: .TouchUpInside)
            
                return cell2
                
            case 3:
                var cell3 = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! UITableViewCell
                
                cell3.layoutMargins = UIEdgeInsetsZero;
                cell3.preservesSuperviewLayoutMargins = false;
                
                cell3.textLabel?.text = "查看菜单"
                
                return cell3
                
            default:
                var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
                return placeHolderCell
                
            }
            
        case 1:
            switch (row) {
            case 0:
                var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
                
                placeHolderCell.layoutMargins = UIEdgeInsetsZero;
                placeHolderCell.preservesSuperviewLayoutMargins = false;
                
                placeHolderCell.textLabel?.text = "营业时间"
                
                return placeHolderCell
              
                
            case 1:
                
            
                var hourCell : UITableViewCell
                
                
                if (expandHours){
                    hourCell = tableView.dequeueReusableCellWithIdentifier("HoursCell", forIndexPath: indexPath) as! UITableViewCell
                }else{
                    hourCell = tableView.dequeueReusableCellWithIdentifier("CurrentHoursCell", forIndexPath: indexPath) as! UITableViewCell
                    
                    hourCell.accessoryView = UIImageView(image: UIImage(named:"downArrow"))
                    
                    hourCell.textLabel?.text = "今天：10AM - 10PM"
                    
            
                }
                
                hourCell.layoutMargins = UIEdgeInsetsZero;
                hourCell.preservesSuperviewLayoutMargins = false;
                
                return hourCell
                
            case 2:
                var cell4 = tableView.dequeueReusableCellWithIdentifier("HoursCell", forIndexPath: indexPath) as! UITableViewCell
                
                cell4.layoutMargins = UIEdgeInsetsZero;
                cell4.preservesSuperviewLayoutMargins = false;
                
                return cell4
                
            default:
                var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
                return placeHolderCell

            }
            
        case 2:
            switch (row) {
            case 0:
                var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
                
                placeHolderCell.layoutMargins = UIEdgeInsetsZero;
                placeHolderCell.preservesSuperviewLayoutMargins = false;
                
                placeHolderCell.textLabel?.text = "特设介绍"
                
                return placeHolderCell
            case 1:
            var cell5 = tableView.dequeueReusableCellWithIdentifier("DescriptionCell", forIndexPath: indexPath) as! UITableViewCell
            
            cell5.layoutMargins = UIEdgeInsetsZero;
            cell5.preservesSuperviewLayoutMargins = false;
            
            return cell5
                
            default:
                var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
                return placeHolderCell
            }
        case 3:
            switch (row){
            case 0:
                var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
                
                placeHolderCell.layoutMargins = UIEdgeInsetsZero;
                placeHolderCell.preservesSuperviewLayoutMargins = false;
                
                placeHolderCell.textLabel?.text = "地址和信息"
                
                return placeHolderCell
            case 1:
                var cell6 = tableView.dequeueReusableCellWithIdentifier("MapCell", forIndexPath: indexPath) as! UITableViewCell
                
                cell6.layoutMargins = UIEdgeInsetsZero;
                cell6.preservesSuperviewLayoutMargins = false;
                
                mapView = self.view.viewWithTag(1) as? MKMapView
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: businessVM!.latitude!, longitude: businessVM!.longitude!)
                annotation.title = businessVM!.nameSChinese
                annotation.subtitle = businessVM!.distance
                
                mapView?.addAnnotation(annotation)
                
                let span = MKCoordinateSpanMake(0.01, 0.01)
                let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(businessVM!.latitude!, businessVM!.longitude!), span: span)
                mapView!.setRegion(region, animated: false)
                
                return cell6
            case 2:
                var cell7 = tableView.dequeueReusableCellWithIdentifier("AddressCell", forIndexPath: indexPath) as! UITableViewCell
                
                cell7.layoutMargins = UIEdgeInsetsZero;
                cell7.preservesSuperviewLayoutMargins = false;
                
                var addressButton : UIButton? = self.view.viewWithTag(1) as? UIButton
                
                var address = businessVM?.address
                
                address = "   \u{f124}   " + address!
                
                let city = businessVM?.city
                let state = businessVM?.state
                
                var fullAddress = address! + ", " + city! + ", " + state!

                addressButton?.setTitle(fullAddress, forState: UIControlState.Normal)
                return cell7
                
            case 3:
                var cell8 = tableView.dequeueReusableCellWithIdentifier("PhoneWebSplitCell", forIndexPath: indexPath) as! UITableViewCell
                
                cell8.layoutMargins = UIEdgeInsetsZero;
                cell8.preservesSuperviewLayoutMargins = false;
                
                var phoneNumberButton : UIButton? = self.view.viewWithTag(1) as? UIButton
                var websiteButton : UIButton? = self.view.viewWithTag(2) as? UIButton
                phoneNumberButton?.setTitle("   \u{f095}   "+businessVM!.phone!, forState: UIControlState.Normal)
                
                if (businessVM?.url != ""){
                    websiteButton?.setTitle("   \u{f0ac}   访问网站", forState: UIControlState.Normal)
                    websiteButton?.addTarget(self, action: "goToWebsiteUrl", forControlEvents: .TouchUpInside)
                }else{
                    websiteButton?.setTitle("   \u{f0ac}   没有网站", forState: UIControlState.Normal)
                }

                
                
                phoneNumberButton?.addTarget(self, action: "callBusiness", forControlEvents: .TouchUpInside)
                
                
                
                return cell8
            default:
                var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
                return placeHolderCell
            }
            
            
            
        default:
            var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
            return placeHolderCell

        }
        
        
    }
    
    
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let row = indexPath.row
        let section = indexPath.section
        
        switch section {
            
        case 0:
            switch row {
            case 0: return 226
            case 1: return 65
            case 2: return 86
            default: return 44
            }
        case 1:
            switch row {
                
            case 1:
                if (expandHours){
                    return 215
                }else{
                    return 44
                }
            case 2: return 215
            default: return 35
            }
         
        case 2:
            switch row {
            case 1: return 91
            default: return 35
            }
        case 3:
            switch row {
            case 0: return 35
            case 1: return 226
            default: return 44
            }
            
        default: return 44
        }
        
        
        
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
//        case 1: return "营业时间"
//        case 2: return "特设介绍"
//        case 3: return "地址和信息"
        default: return ""
        }
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}

/**
*  UITableViewDelegate
*/
extension DetailViewController : UITableViewDelegate {
    /**
    Tells the delegate that the specified row is now selected.
    
    :param: tableView A table-view object informing the delegate about the new row selection.
    :param: indexPath An index path locating the new selected row in tableView.
    */
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.section == 1 && indexPath.section == 1){
            
            if (expandHours){
                expandHours = false
            }else{
               expandHours = true
            }
            
            tableView.reloadData()
        }
        
        
    }
}