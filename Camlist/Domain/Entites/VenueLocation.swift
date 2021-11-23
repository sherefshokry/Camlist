//
//  Location.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

public struct VenueLocation: Equatable,Codable {
    public let address: String?
    
    public init(address: String?) {
        self.address = address
    }
}
