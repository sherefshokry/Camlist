//
//  LoadingVenuesWithCurrentUserLocation.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

protocol FetchVenueUseCase {
    func execute(completion: @escaping (Result<[Venue],Error>) -> Void)
}


final class DefaultFetchVenueUseCase: FetchVenueUseCase {
    
    let venueRepository: VenueRepository
    
    init(venueRepository: VenueRepository){
        self.venueRepository =  venueRepository
    }
    
    func execute(completion: @escaping (Result<[Venue], Error>) -> Void) {
        venueRepository.fetchVenuesList() { result in
            completion(result)
        }

    }
    
    
}



public struct UserLocation: Codable {
    let lat: Double
    let lng: Double
}
