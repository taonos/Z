//
//  SocialBusiness_UserViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-04.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveArray
import Dollar
import AVOSCloud

// TODO: make this class conform to `ISocialBusiness_UserViewModel`
public final class SocialBusiness_UserViewModel {
    
    // MARK: - Outputs
    public var profileImage: PropertyOf<UIImage?> {
        return PropertyOf(_profileImage)
    }
    public var nickname: PropertyOf<String> {
        return PropertyOf(_nickname)
    }
    public var ageGroup: PropertyOf<String> {
        return PropertyOf(_ageGroup)
    }
    public var horoscope: PropertyOf<String> {
        return PropertyOf(_horoscope)
    }
//    public var status: PropertyOf<String> {
//        return PropertyOf(_status)
//    }
//    public var participationType: PropertyOf<String> {
//        return PropertyOf(_participationType)
//    }
    public var gender: PropertyOf<String> {
        return PropertyOf(_gender)
    }
    
    public var user: PropertyOf<User> {
        return PropertyOf(_user)
    }
    
    private let _nickname: MutableProperty<String>
    private let _ageGroup: MutableProperty<String>
    private let _horoscope: MutableProperty<String>
//    private let _status: MutableProperty<String>
//    private let _participationType: MutableProperty<String>
    private let _gender: MutableProperty<String>
    private let _profileImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.profilepicture))
    private let _user: MutableProperty<User> = MutableProperty(User())
    
    // MARK: - Properties
    private let imageService: IImageService
    private let participationService: IParticipationService

    
    // MARK: - Initializers
    public init(participationService: IParticipationService, imageService: IImageService, user: User?, nickname: String?, ageGroup: String?, horoscope: String?, gender: String?, profileImage: AVFile?) {
        self.participationService = participationService
        self.imageService = imageService
        
        if let user = user {
            _user.put(user)
        }
        
        if let nickname = nickname {
            _nickname = MutableProperty(nickname)
        } else {
            _nickname = MutableProperty("")
        }
        
        if let ageGroup = ageGroup {
            _ageGroup = MutableProperty(ageGroup)
        } else {
            _ageGroup = MutableProperty("")
        }
        
        if let horoscope = horoscope {
            _horoscope = MutableProperty(horoscope)
        } else {
            _horoscope = MutableProperty("")
        }
        
//        if let status = status {
//            _status = MutableProperty(status)
//        } else {
//            _status = MutableProperty("")
//        }
//        
//        if let participationType = participationType {
//            _participationType = MutableProperty(participationType)
//        } else {
//            _participationType = MutableProperty("")
//        }
        
        if let gender = gender {
            _gender = MutableProperty(gender)
        } else {
            _gender = MutableProperty("")
        }
        

        if let url = profileImage?.url, nsurl = NSURL(string: url) {
            self.imageService.getImage(nsurl)
                |> start(next: {
                    self._profileImage.put($0)
                })
        }
    }
}
