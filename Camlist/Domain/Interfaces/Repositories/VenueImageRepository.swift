//
//  VenueImageRepository.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

public protocol VenueImageRepository {
    func fetchVenueImage(cached: @escaping (VenueImage) -> Void,completion: @escaping (Result<VenueImage,Error>) -> Void)
}
