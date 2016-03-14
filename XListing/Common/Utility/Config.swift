//
//  Config.swift
//  XListing
//
//  Created by Hong Zhu on 2016-02-05.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import SDWebImage
import AVOSCloud
import CocoaLumberjack

public final class Config {
    
    public static func trackAppOpenedWithLaunchOptions(launchOptions: [NSObject : AnyObject]) {
        
        AVAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
    }
    
    public class func config() {
        
        configureCocoaLumberjack()
        configureSDWebImage()
        configureLeanCloud()
        configureRongCloud()
    }
    
    private class func configureSDWebImage() {
        // FIXME: temporary until this is resolved: https://github.com/facebook/AsyncDisplayKit/issues/955
        SDImageCache.sharedImageCache().shouldDecompressImages = false
        SDWebImageDownloader.sharedDownloader().shouldDecompressImages = false
    }
    
    private class func configureLeanCloud() {
        let id = "id"
        let key = "key"
        let dict = loadKeys(id, key)
        AVOSCloud.setApplicationId(dict[id], clientKey: dict[key])
        AVOSCloud.setLastModifyEnabled(true)
        AVOSCloud.setVerbosePolicy(kAVVerboseAuto)
        
        AVAnalytics.setAnalyticsEnabled(true)
        #if DEBUG
            AVAnalytics.setLogEnabled(true)
        #endif
        
        
        //        User.enableAutomaticUser()
        
        User.registerSubclass()
        Me.registerSubclass()
        User_Business_Participation.registerSubclass()
        Address.registerSubclass()
        Business.registerSubclass()
    }
    
    private class func configureRongCloud() {
        let rongcloudKey = "rongcloudKey"
        let dict = loadKeys(rongcloudKey)
        RCIM.sharedRCIM().initWithAppKey(dict[rongcloudKey])
//        RCIM.sharedRCIM().connectWithToken("YourTestUserToken",
//            success: { (userId) -> Void in
//                print("登陆成功。当前登录的用户ID：\(userId)")
//            }, error: { (status) -> Void in
//                print("登陆的错误码为:\(status.rawValue)")
//            }, tokenIncorrect: {
//                //token过期或者不正确。
//                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
//                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//                print("token错误")
//        })
    }
    
    private static func loadKeys(keys: String...) -> [String: String] {
        var result = [String: String]()
        
        let env = NSProcessInfo.processInfo().environment
        guard let mode = env["exec_mode"] as String! else {
            fatalError("Missing execution mode! Please refer to instructions on how to setup the project.")
        }
        
        LSLogInfo("We are in \(mode.uppercaseString) mode!")
        
        let path = NSBundle.mainBundle().pathForResource("Parse", ofType: "plist")
        guard let dict = NSDictionary(contentsOfFile: path!) else {
            fatalError("Missing `Parse.plist` file which hosts keys for initializing the app. Please refer to instructions on how to setup the project.")
        }
        
        for key in keys {
            guard let modeDict: AnyObject = dict.objectForKey(mode), value = modeDict.objectForKey(key) as? String else {
                fatalError("Cannot find the key: \(key)")
            }
            result[key] = value
        }
        
        return result
    }
    
    
    private class func configureCocoaLumberjack() {
        let consoleFormatter = ConsoleFormatter()
        let aslFormatter = ASLFormatter()
        
        configConsoleLogger(consoleFormatter)
        configAppleSystemLogger(aslFormatter)
    }
    
    private class func configConsoleLogger(formatter: ConsoleFormatter? = nil) {
        let pink = UIColor(red: 255.0/255.0, green: 58.0/255.0, blue: 159.0/255.0, alpha: 1.0)
        let blue = UIColor(red: 135.0/255.0, green: 206.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        let logger = DDTTYLogger.sharedInstance()
        
        if let formatter = formatter {
            logger.logFormatter = formatter
        }
        
        // Enable log color in console
        logger.colorsEnabled = true
        
        // Set color for a log level
        logger.setForegroundColor(blue, backgroundColor: nil, forFlag: DDLogFlag.Info)
        logger.setForegroundColor(pink, backgroundColor: nil, forFlag: DDLogFlag.Debug)
        
        // Console log
        DDLog.addLogger(logger, withLevel: DDLogLevel.Verbose)
    }
    
    private class func configAppleSystemLogger(formatter: ASLFormatter? = nil) {
        let logger = DDASLLogger.sharedInstance()
        if let formatter = formatter {
            logger.logFormatter = formatter
        }
        
        DDLog.addLogger(logger, withLevel: DDLogLevel.Info)
    }
    
    private class func configFileLogger(formatter: ConsoleFormatter? = nil) {
        
        let fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hour rolling
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        if let formatter = formatter {
            fileLogger.logFormatter = formatter
        }
        
        DDLog.addLogger(fileLogger, withLevel: DDLogLevel.Info)
    }
}