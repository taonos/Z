//
//  PopoverDatePicker.swift
//  XListing
//
//  Created by Bruce Li on 2015-07-19.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

public final class PopoverDatePicker : NSObject, UIPopoverPresentationControllerDelegate, DataPickerViewControllerDelegate {
    
    public typealias PopDatePickerCallback = (newDate : NSDate, forTextField : UITextField)->()
    
    var datePickerVC : PopDateViewController
    var popover : UIPopoverPresentationController?
    var textField : UITextField!
    var dataChanged : PopDatePickerCallback?
    var presented = false
    
    public init(forTextField: UITextField) {
        
        datePickerVC = PopDateViewController()
        self.textField = forTextField
        super.init()
    }
    
    public func pick(inViewController : UIViewController, initDate : NSDate?, dataChanged : PopDatePickerCallback) {
        
        if presented {
            return  // we are busy
        }
        
        datePickerVC.delegate = self
        datePickerVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        datePickerVC.preferredContentSize = CGSizeMake(500,224)
        datePickerVC.currentDate = initDate
        
        popover = datePickerVC.popoverPresentationController
        if let _popover = popover {
            
            var height = (UIScreen.mainScreen().bounds.size.height)/2
            var width = (UIScreen.mainScreen().bounds.size.width)/2
            
            _popover.sourceView = textField
            _popover.sourceRect = CGRectMake(width-250,height-250,0,0)
            _popover.delegate = self
            _popover.permittedArrowDirections = UIPopoverArrowDirection.allZeros
            self.dataChanged = dataChanged
            inViewController.presentViewController(datePickerVC, animated: true, completion: nil)
            presented = true
        }
    }
    
    public func adaptivePresentationStyleForPresentationController(PC: UIPresentationController) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.None
    }
    
    func datePickerVCDismissed(date : NSDate?) {
        
        if let _dataChanged = dataChanged {
            
            if let _date = date {
                
                _dataChanged(newDate: _date, forTextField: textField)
                
            }
        }
        presented = false
    }
}