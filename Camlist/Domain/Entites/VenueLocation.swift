//
//  Location.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

struct VenueLocation {
    let lat: Double
    let lng: Double
    let distance: Int
    let city: String?
    let state: String?
    let country: String
    let formattedAddress: [String]
    let address: String?
}
