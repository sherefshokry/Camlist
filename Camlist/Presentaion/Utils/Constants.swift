//
//  Constants.swift
//  Camlist
//
//  Created by SherifShokry on 21/11/2021.
//

import Foundation

class Constants {
 
    struct APPConfigrution{
        static var BASE_URL =  "API_BASE_URL"
        static var API_KEY = "API_KEY"
        static var APP_STATUS = "APP_STATUS"
    }
    
    struct Strings{
        static var NEAR_BY = "Near By"
        static var REAL_TIME = "Realtime"
        static var SINGLE_UPDATE = "Single Update"
        static var SOMETHING_WRONG = "Something Went Wrong !!"
        static var NO_DATA = "No Data Found !!"
        static var SINGLE_UPDATE_MSG = "Do you want to change current app mode to Single Update"
        static var REALTIME_MSG = "Do you want to change current app mode to Realtime"
        static var WAIT = "Please Wait ...."
        static var UNABLE_FETCH_LOCATION = "Unable to fetch location"
    }
    
    struct DefaultCaching{
        static var USER_LOCATION = "USER_LOCATION"
    }
    
    struct CustomNotification{
        static var UPDATE_LOCATION_NOTIFICATION = "UPDATE_LOCATION_NOTIFICATION"
    }
    
}
