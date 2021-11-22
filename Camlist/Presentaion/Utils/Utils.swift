//
//  Utils.swift
//  Camlist
//
//  Created by SherifShokry on 22/11/2021.
//

import Foundation


class Utils {
    
    static func setAppStatus(isRealTime: Bool){
        UserDefaults.standard.set(isRealTime, forKey: Constants.APPConfigrution.APP_STATUS)
    }
    
    static func getAppStatus() -> AppStatus {
        if let status = UserDefaults.standard.value(forKey: Constants.APPConfigrution.APP_STATUS) as? Bool{
            return status ? .realTime : .singleUpdate
        }
        return .realTime
    }
    
}
