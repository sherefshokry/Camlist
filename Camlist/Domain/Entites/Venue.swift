//
//  Venue.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

public struct Venue: Equatable,Codable {
    public let id: String
    public let name: String
    public let location: VenueLocation
    
    public init(id: String, name: String, location: VenueLocation) {
        self.id = id
        self.name = name
        self.location = location
    }
}
