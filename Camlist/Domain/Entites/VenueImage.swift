//
//  VenuePhoto.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

public struct VenueImage{
    let id: String
    let prefix: String
    let suffix: String
    let width:  Int
    let height: Int
    
    public init(id: String, prefix: String, suffix: String, width: Int, height: Int) {
        self.id = id
        self.prefix = prefix
        self.suffix = suffix
        self.width = width
        self.height = height
    }
}
