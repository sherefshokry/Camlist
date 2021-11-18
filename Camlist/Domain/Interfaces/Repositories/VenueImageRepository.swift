//
//  VenueImageRepository.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

protocol VenuesImageRepository {
    func fetchVenueImage(venueId: Int,completion: @escaping (Result<VenueImage,Error>) -> Void)
}
