//
//  VenuesRepository.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

protocol VenueRepository {
    func fetchVenueList(completion: @escaping (Result<[Venue],Error>) -> Void)
}

struct VenueRepoWithFallBack: VenueRepository {
    
    let primary :  VenueRepository
    let fallback : VenueRepository

    func fetchVenueList(completion: @escaping (Result<[Venue], Error>) -> Void) {
        primary.fetchVenueList { result in
            switch result{
            case let .success(venueList):
                completion(.success(venueList))
            case  .failure(_):
                fallback.fetchVenueList(completion: completion)
            }
        }
    }

}
