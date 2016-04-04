//
//  FeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ReactiveArray

final class FeaturedListViewModel : _BaseViewModel, IFeaturedListViewModel, ViewModelInjectable {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    let collectionDataSource: Driver<[BusinessInfo]>
    
    // MARK: - Properties
    // MARK: Services
    private let businessRepository: IBusinessRepository
    private let userRepository: IUserRepository
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    
    
    // MARK: - Initializers
    typealias Dependency = (router: IRouter, businessRepository: IBusinessRepository, userRepository: IUserRepository, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService)
    
    typealias Token = Void
    
    typealias Input = (modelSelected: Driver<BusinessInfo>, refreshTrigger: Driver<Void>, fetchMoreTrigger: Observable<Void>)
    
    init(dep: Dependency, token: Token, input: Input) {
        
        businessRepository = dep.businessRepository
        userRepository = dep.userRepository
        geoLocationService = dep.geoLocationService
        userDefaultsService = dep.userDefaultsService
        
        collectionDataSource = input.refreshTrigger
            .flatMapLatest { op -> Driver<[Business]> in
                dep.businessRepository.findByCurrentLocation(input.fetchMoreTrigger)
                    .asDriver {
                        // FIXME: This is possibly a crash
                        dep.router.presentError($0 as! NetworkError)
                        return Driver.just([Business]())
                    }
            }
            .map { $0.map { BusinessInfo(business: $0) } }
        
        
        super.init(router: dep.router)
        
        input.modelSelected
            .driveNext {
                dep.router.toSoclaBusiness($0)
            }
            .addDisposableTo(disposeBag)
    }
    
    // MARK: - API
    
    
}