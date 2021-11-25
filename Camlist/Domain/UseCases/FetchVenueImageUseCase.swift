//
//  FetchVenueImageUseCase.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

protocol FetchVenueImageUseCase: AnyObject{
    func execute(cached: @escaping (VenueImage) -> Void, completion: @escaping (Result<VenueImage,Error>) -> Void)
}

final class DefaultFetchVenueImageUseCase: FetchVenueImageUseCase{
   
    let venueImageRepository: VenueImageRepository
    
    init(venueRepository: VenueImageRepository){
        self.venueImageRepository =  venueRepository
    }
    
    
    func execute(cached: @escaping  (VenueImage) -> Void,completion: @escaping (Result<VenueImage, Error>) -> Void)  {
        venueImageRepository.fetchVenueImage(cached: cached, completion: completion)
    }
    
}
