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
    
    lazy var apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("API KEY must not be empty in plist")
        }
        return apiKey
    }()

}
