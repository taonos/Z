//
//  DetailViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Realm
import SwiftTask
import ReactKit

public class DetailViewModel : BaseViewModel, IDetailViewModel {
    
    private let wantToGoService: IWantToGoService
    
    public init(datamanager: IDataManager, realmService: IRealmService, wantToGoService: IWantToGoService) {
        self.wantToGoService = wantToGoService
        super.init(datamanager: datamanager, realmService: realmService)
    }
    
    public func goingToBusiness(business: BusinessViewModel, thisWeek: Bool, thisMonth: Bool, later: Bool) -> Task<Int, WantToGoDAO, NSError> {
        return wantToGoService.goingToBusiness(business.objectId!, thisWeek: thisWeek, thisMonth: thisMonth, later: later)
    }
}