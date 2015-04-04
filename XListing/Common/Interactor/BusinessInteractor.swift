//
//  BusinessInteractor.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-31.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public class BusinessInteractor : IBusinessInteractor {
    private let geolocationDataManager: IGeolocationDataManager
    private let businessDataManager: IBusinessDataManager
    
    public init(businessDataManager: IBusinessDataManager, geolocationDataManager: IGeolocationDataManager) {
        self.businessDataManager = businessDataManager
        self.geolocationDataManager = geolocationDataManager
    }

    ///
    ///
    ///
    ///
    public func saveBusiness(business: BusinessDomain) -> Task<Int, Bool, NSError> {
        let b = business.toEntity()
        let task = businessDataManager.save(b)

        return task
    }

    ///
    ///
    ///
    ///
    public func findBusinessBy(query: PFQuery) -> Task<Int, [BusinessDomain], NSError> {
        return retrieveBusinessWithGeolocation(query)
    }

}

// protected methods
extension BusinessInteractor {

    /// Retrieve businesses based on the query value. And encode the geolocation distance to each business.
    ///
    /// :params: query A PFQuery
    /// :returns: A Task which contains an array of BusinessDomain
    public func retrieveBusinessWithGeolocation(var _ query: PFQuery = BusinessEntity.query()) -> Task<Int, [BusinessDomain], NSError> {
        // acquire current location
        let currentLocationTask = geolocationDataManager.getCurrentGeoPoint()
        let resultTask = currentLocationTask.success { currentgp -> Task<Int, [BusinessDomain], NSError> in

            // retrieve a list of featured businesses
            let featuredBusinessesArrTask = self.businessDataManager.findBy(query)
            let businessDomainConversionTask = featuredBusinessesArrTask.success { businessEntityArr -> [BusinessDomain] in

                // map to domain model
                let businessDomainArr = businessEntityArr.map { businessEntity -> BusinessDomain in
                    let distance = businessEntity.geopoint?.distanceInKilometersTo(currentgp)

                    let businessDomain = BusinessDomain()
                    businessDomain.fromEntity(businessEntity, distance: distance)
                    return businessDomain
                }

                return businessDomainArr
            }

            return businessDomainConversionTask
        }

        return resultTask
    }
}