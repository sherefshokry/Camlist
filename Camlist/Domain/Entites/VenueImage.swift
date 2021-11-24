//
//  VenuePhoto.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

public struct VenueImage: Equatable{
    public let id: String
    public let prefix: String
    public let suffix: String
    public let width:  Int
    public let height: Int
    
    public init(id: String, prefix: String, suffix: String, width: Int, height: Int) {
        self.id = id
        self.prefix = prefix
        self.suffix = suffix
        self.width = width
        self.height = height
    }
}
