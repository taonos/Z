//
//  DetailRoute.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-11.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol DetailRoute : WithDataRoute {
    func pushWithData<T: Business>(business: T)
}