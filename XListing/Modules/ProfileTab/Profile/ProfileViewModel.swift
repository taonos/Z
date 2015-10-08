//
// ProfileViewModel.swift
// XListing
//
// Created by Lance Zhu on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public protocol ProfileNavigator : class {
    func pushSocialBusiness(business: Business, animated: Bool)
    func presentProfileEdit(user: User, animated: Bool, completion: CompletionHandler?)
}

public final class ProfileViewModel : IProfileViewModel {

    // MARK: - Inputs

    // MARK: - Outputs
    public let profileBusinessViewModelArr: MutableProperty<[ProfileBusinessViewModel]> = MutableProperty([ProfileBusinessViewModel]())

    
    // MARK: - Properties
    // MARK: Services
    private let businessService: IBusinessService
    private let participationService: IParticipationService
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    private let imageService: IImageService
    
    // MARK: ViewModels
    public let profileUpperViewModel: IProfileUpperViewModel

//    private let _profileHeaderViewModel = MutableProperty<IProfileHeaderViewModel?>(nil)
//    public var profileHeaderViewModel: PropertyOf<IProfileHeaderViewModel?> {
//        return PropertyOf(_profileHeaderViewModel)
//    }

    // MARK: Variables
    public weak var navigator: ProfileNavigator!
    private let participationArr: MutableProperty<[Participation]> = MutableProperty([Participation]())
    private let businessArr: MutableProperty<[Business]> = MutableProperty([Business]())
    private var user: User?
    
    
    public init(participationService: IParticipationService, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService) {
        
        self.participationService = participationService
        self.businessService = businessService
        self.userService = userService
        self.geoLocationService = geoLocationService
        self.userDefaultsService = userDefaultsService
        self.imageService = imageService
        
        profileUpperViewModel = ProfileUpperViewModel(userService: userService, imageService: imageService)
    }

    // MARK: - API
    
//    public func getUserInfo() -> SignalProducer<Void, NSError> {
//        return self.userService.currentLoggedInUser()
//            |> on(next: { user in
//                self.user = user
//                var viewmodel = ProfileHeaderViewModel(imageService: self.imageService, user: user, nickname: user.nickname, ageGroup: user.ageGroup_, horoscope: user.horoscope_, gender: user.gender_, profileImage: user.profileImg_, status: user.status)
//                self._profileHeaderViewModel.put(viewmodel)
//                self.getParticipations(user)
//                    |> start()
//            })
//            |> map { _ in }
//    }

    public func pushSocialBusinessModule(section: Int, animated: Bool) {
        navigator.pushSocialBusiness(businessArr.value[section], animated: animated)
    }

    public func presentProfileEditModule(animated: Bool, completion: CompletionHandler? = nil) {
        if let user = user {
            navigator.presentProfileEdit(user, animated: animated, completion: completion)
        }
    }

    public func undoParticipation(index: Int) -> SignalProducer<Bool, NSError> {
        return participationService.delete(participationArr.value[index])
            |> on(
                next: { _ in
                    ProfileLogInfo("participation backend completed")
                    self.participationArr.value.removeAtIndex(index)
                }
            )
    }

    // MARK: - Others

    private func getParticipations(user : User) -> SignalProducer<[ProfileBusinessViewModel], NSError> {
        let query = Participation.query()!
        typealias Property = Participation.Property
        query.whereKey(Property.User.rawValue, equalTo: user)
        query.includeKey(Property.Business.rawValue)
        
        return participationService.findBy(query)
            |> on(next: { participations in
                self.participationArr.put(participations)
                self.businessArr.put(participations.map { $0.business })
            })
            |> map { participations -> [ProfileBusinessViewModel] in

                // map participation to its view model
                return participations.map {
                    let business = $0.business
                    let viewmodel = ProfileBusinessViewModel(geoLocationService: self.geoLocationService, imageService: self.imageService, businessName: business.nameSChinese, city: business.city, district: business.district, cover: business.cover_, geolocation: business.geolocation, aaCount: business.aaCount, treatCount: business.treatCount, toGoCount: business.toGoCount)
                    return viewmodel
                }
            }
            |> on(
                next: { response in
                    self.profileBusinessViewModelArr.put(response)
                },
                error: { ProfileLogError($0.customErrorDescription) }
            )
    }

}
