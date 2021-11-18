//
//  VenuesRepository.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

protocol VenuesRepository {
    func fetchVenuesList(userLocation: UserLocation, completion: @escaping (Result<[Venue],Error>) -> Void)
}
