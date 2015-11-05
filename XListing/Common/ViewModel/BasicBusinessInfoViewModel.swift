//
//  BasicBusinessInfoViewModel.swift
//  XListing
//
//  Created by Anson on 2015-10-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public class BasicBusinessInfoViewModel : IBasicBusinessInfoViewModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs

    private let _businessName: ConstantProperty<String>
    public var businessName: AnyProperty<String> {
        return AnyProperty(_businessName)
    }

    private let _city: ConstantProperty<String>
    public var city: AnyProperty<String> {
        return AnyProperty(_city)
    }

    private let _eta: MutableProperty<String?> = MutableProperty(nil)
    public var eta: AnyProperty<String?> {
        return AnyProperty(_eta)
    }

    private let _price: MutableProperty<Int?>
    public var price: AnyProperty<Int?> {
        return AnyProperty(_price)
    }

    private let _district: ConstantProperty<String>
    public var district: AnyProperty<String> {
        return AnyProperty(_district)
    }

    // MARK: - Properties

    // MARK: Services
    private let geoLocationService: IGeoLocationService

    // MARK: - Initializers

    public required init(geoLocationService: IGeoLocationService, businessName: String?, city: String?, district: String?, price: Int?, geolocation: Geolocation?) {
        
        self.geoLocationService = geoLocationService
        
        if let businessName = businessName {
            self._businessName = ConstantProperty(businessName)
        } else {
            self._businessName = ConstantProperty("")
        }
        if let city = city {
            self._city = ConstantProperty(city)
        } else {
            self._city = ConstantProperty("")
        }
        if let district = district {
            self._district = ConstantProperty(district)
        } else {
            self._district = ConstantProperty("")
        }
        
        self._price = MutableProperty(price)
        
        
        if let geolocation = geolocation {
            setupEta(CLLocation(latitude: geolocation.latitude, longitude: geolocation.longitude))
                .start()
        }
    }


    private func setupEta(destination: CLLocation) -> SignalProducer<NSTimeInterval, NSError> {
        return geoLocationService.calculateETA(destination)
            .on(
                next: { interval in
                    let minute = Int(ceil(interval / 60))
                    self._eta.value = "\(minute)分钟"
                },
                failed: { error in
                    FeaturedLogError(error.description)
                }
            )
    }
}