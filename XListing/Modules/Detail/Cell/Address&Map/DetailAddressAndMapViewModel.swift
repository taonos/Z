//
//  DetailAddressAndMapViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import MapKit

public struct DetailAddressAndMapViewModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    private let _fullAddress: ConstantProperty<String>
    public var fullAddress: PropertyOf<String> {
        return PropertyOf(_fullAddress)
    }
    private let _annotation: ConstantProperty<MKPointAnnotation>
    public var annotation: PropertyOf<MKPointAnnotation> {
        return PropertyOf(_annotation)
    }
    private let _cellMapRegion: ConstantProperty<MKCoordinateRegion>
    public var cellMapRegion: PropertyOf<MKCoordinateRegion> {
        return PropertyOf(_cellMapRegion)
    }
    
    // MARK: - Properties
    // MARK: Services
    private let geoLocationService: IGeoLocationService
    private let businessLocation: ConstantProperty<CLLocation>
    
    // MARK: - API
    
    // MARK: Initializers
    public init(geoLocationService: IGeoLocationService, businessName: String?, address: String?, city: String?, state: String?, businessLocation: CLLocation) {
        self.geoLocationService = geoLocationService
        
        self._fullAddress = ConstantProperty<String>("   \u{f124}   \(address!), \(city!), \(state!)")
        
        self.businessLocation = ConstantProperty(businessLocation)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = businessLocation.coordinate
        annotation.title = businessName
        self._annotation = ConstantProperty(annotation)
        
        /**
        *  region for the map in cell
        */
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: businessLocation.coordinate, span: span)
        self._cellMapRegion = ConstantProperty(region)
        
    }
}