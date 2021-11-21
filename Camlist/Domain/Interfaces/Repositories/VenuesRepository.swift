//
//  VenuesRepository.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

protocol VenueRepository {
    func fetchVenuesList(completion: @escaping (Result<[Venue],Error>) -> Void)
}

struct VenueRepoWithFallBack: VenueRepository {
    
    let primary :  VenueRepository
    let fallback : VenueRepository

    func fetchVenuesList(completion: @escaping (Result<[Venue], Error>) -> Void) {
        primary.fetchVenuesList { result in
            switch result{
            case let .success(venueList):
                completion(.success(venueList))
            case  .failure(_):
                fallback.fetchVenuesList(completion: completion)
            }
        }
    }

}
