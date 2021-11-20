//
//  FetchVenueImageUseCase.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

protocol FetchVenueImageUseCase {
    func execute(venueId: String, completion: @escaping (Result<[VenueImage],Error>) -> Void) -> HTTPClientTask
}

final class DefaultFetchVenueImageUseCase: FetchVenueImageUseCase{
   
    let venueImageRepository: VenueImageRepository
    
    init(venueRepository: VenueImageRepository){
        self.venueImageRepository =  venueRepository
    }
    
    
    func execute(venueId: String, completion: @escaping (Result<[VenueImage], Error>) -> Void) -> HTTPClientTask {
       let task = venueImageRepository.fetchVenueImage(venueId: venueId) { result in
            completion(result)
        }
        return task
    }
    
}
