//
//  ProfileEditRoute.swift
//  XListing
//
//  Created by Bruce Li on 2015-08-04.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol ProfileEditRoute : WithDataRoute {
    func presentWithData<T: User>(user: T, completion: CompletionHandler?, dismissCallback: CompletionHandler?)
}