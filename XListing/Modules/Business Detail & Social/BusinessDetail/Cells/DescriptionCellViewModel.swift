//
//  DescriptionCellViewModel.swift
//  XListing
//
//  Created by Bruce Li on 2015-09-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class DescriptionCellViewModel {

    // MARK: - Outputs
    private let _description: MutableProperty<String>
    public var description: PropertyOf<String> {
        return PropertyOf(_description)
    }
    
    // MARK: - Initializers
    public init(description: String?) {
        
        if let description = description {
            _description = MutableProperty(description)
        } else {
            _description = MutableProperty("")
        }
        
    }
}