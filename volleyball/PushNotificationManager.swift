//
//  PushNotificationManager.swift
//  volleyball
//
//  Created by Master on 2015/08/04.
//  Copyright (c) 2015年 三ツ井杏希. All rights reserved.
//

import UIKit

class PushNotificationManager: NSObject {
    class var isPushNotificationEnable: Bool {
        let osVersion = UIDevice.currentDevice().systemVersion
        if osVersion < "8.0" {
            let types = UIApplication.sharedApplication().enabledRemoteNotificationTypes()
            if types == UIRemoteNotificationType.None {
                // push notification disabled
                return false
            }else{
                // push notification enable
                return true
            }
        }else {
            if UIApplication.sharedApplication().isRegisteredForRemoteNotifications() {
                // push notification enable
                return true
            }else {
                // push notification disabled
                return false
            }
        }
    }
    
    class func openAppSettingPage() -> Void {
        let application = UIApplication.sharedApplication()
        let osVersion = UIDevice.currentDevice().systemVersion
        if osVersion < "8.0" {
            // not supported
        }else{
            let url = NSURL(string:UIApplicationOpenSettingsURLString)!
            UIApplication.sharedApplication().openURL(url)
        }
    }
}
