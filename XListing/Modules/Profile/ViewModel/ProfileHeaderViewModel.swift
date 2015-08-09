//
//  ProfileHeaderViewModel.swift
//  XListing
//
//  Created by Anson on 2015-07-26.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud
import Dollar

public final class ProfileHeaderViewModel {
    
    // MARK: - Input
    
    // MARK: - Output
    public let name: ConstantProperty<String>
    public let horoscope: ConstantProperty<String>
    public let city: ConstantProperty<String>
    public let district: ConstantProperty<String>
    public let ageGroup: ConstantProperty<String>
    public let eta: MutableProperty<String> = MutableProperty("")
    public let coverImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.profilepicture))
    
    // MARK: - Services
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    public init(geoLocationService: IGeoLocationService, imageService: IImageService, name: String?, city: String?, district: String?, horoscope: String?, ageGroup: String?, cover: AVFile?, geopoint: AVGeoPoint?) {
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        
        if let name = name {
            self.name = ConstantProperty(name)
        } else {
            self.name = ConstantProperty("")
        }
        if let city = city {
            self.city = ConstantProperty(city)
        } else {
            self.city = ConstantProperty("")
        }
        if let district = district {
            self.district = ConstantProperty(district)
        } else {
            self.district = ConstantProperty("")
        }
        
        
        func convertHoroscope(horoscope: String?) -> String {
            if let horoscope = horoscope {
                switch(horoscope){
                case "白羊座": return horoscope + "♈️"
                case "金牛座": return horoscope + "♉️"
                case "双子座": return horoscope + "♊️"
                case "巨蟹座": return horoscope + "♋️"
                case "狮子座": return horoscope + "♌️"
                case "处女座": return horoscope + "♍️"
                case "天秤座": return horoscope + "♎️"
                case "天蝎座": return horoscope + "♏️"
                case "射手座": return horoscope + "♐️"
                case "摩羯座": return horoscope + "♑️"
                case "水瓶座": return horoscope + "♒️"
                case "双鱼座": return horoscope + "♓️"
                default: return ""
                }
            }
            else {
                return ""
            }
        }
        self.horoscope = ConstantProperty(convertHoroscope(horoscope))
        
        
        if let ageGroup = ageGroup {
            var temp = ageGroup + "后"
            self.ageGroup = ConstantProperty(temp)
        } else {
            self.ageGroup = ConstantProperty("")
        }
        
        if let geopoint = geopoint {
            setupEta(CLLocation(latitude: geopoint.latitude, longitude: geopoint.longitude))
        }

        if let url = cover?.url, nsurl = NSURL(string: url) {
            imageService.getImage(nsurl)
                |> start(next: {
                    self.coverImage.put($0)
                })
        }
        
    }
    
    // MARK: Setup
    
    private func setupEta(destination: CLLocation) {
        self.geoLocationService.calculateETA(destination)
            |> start(
                next: { interval in
                    let minute = Int(ceil(interval / 60))
                    self.eta.put(" \(CITY_DISTANCE_SEPARATOR) 开车\(minute)分钟")
                },
                error: { error in
                    FeaturedLogError(error.description)
                }
            )
    }
}