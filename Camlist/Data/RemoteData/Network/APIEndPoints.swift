//
//  VenueEndPoint.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

class APIEndPoints {
    private init(){}
    
    static func getVenuesURLRequest(userLocation: UserLocation) -> URLRequest {
        let queryItems = [URLQueryItem(name: "limit", value: "20"),
                          URLQueryItem(name: "radius", value: "1000"),
                          URLQueryItem(name: "ll", value: "\(userLocation.lat),\(userLocation.lng)")]
        return Endpoint.url(path: "/search", method: .get, queryItems: queryItems)
    }
    
    static func getVenueImageURLRequest(venueID: String) -> URLRequest {
        return Endpoint.url(path: "/\(venueID)/photos", method: .get, queryItems: [])
    }
    
}







