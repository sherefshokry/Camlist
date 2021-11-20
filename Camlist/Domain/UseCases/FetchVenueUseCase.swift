//
//  LoadingVenuesWithCurrentUserLocation.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

protocol FetchVenueUseCase {
    func execute(userLocation: UserLocation, completion: @escaping (Result<[Venue],Error>) -> Void)
}


final class DefaultFetchVenueUseCase: FetchVenueUseCase {
    
    let venueRepository: VenuesRepository
    
    init(venueRepository: VenuesRepository){
        self.venueRepository =  venueRepository
    }
    
    func execute(userLocation: UserLocation, completion: @escaping (Result<[Venue], Error>) -> Void) {
        
        venueRepository.fetchVenuesList(userLocation: userLocation) { result in
            completion(result)
        }

    }
    
    
}



public struct UserLocation {
    let lat: Double
    let lng: Double
}
