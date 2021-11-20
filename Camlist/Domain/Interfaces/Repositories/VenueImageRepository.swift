//
//  VenueImageRepository.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

protocol VenueImageRepository {
    func fetchVenueImage(venueId: String,completion: @escaping (Result<[VenueImage],Error>) -> Void) -> HTTPClientTask
}
