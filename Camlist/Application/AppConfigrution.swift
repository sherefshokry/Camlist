//
//  AppConfigrution.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

public final class AppConfigrution {
    
    lazy var baseUrl: String = {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
            fatalError("baseURL must not be empty in plist")
        }
        return baseURL
    }()
    
    lazy var clientID: String = {
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String else {
            fatalError("clientID must not be empty in plist")
        }
        return clientID
    }()
    
    lazy var clientSecret: String = {
        guard let clientSecret = Bundle.main.object(forInfoDictionaryKey: "CLIENT_SECRET") as? String else {
            fatalError("clientSecret must not be empty in plist")
        }
        return clientSecret
    }()
    
    lazy var apiVersion: String = {
        guard let version = Bundle.main.object(forInfoDictionaryKey: "API_VERSION") as? String else {
            fatalError("apiVersion must not be empty in plist")
        }
        return version
    }()

}
