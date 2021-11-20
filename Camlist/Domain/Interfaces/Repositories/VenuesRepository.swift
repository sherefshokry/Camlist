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

final class DefaultVenueRepository: VenuesRepository {
   
    let client: HTTPClient
    
    init(client: HTTPClient){
        self.client = client
    }
    
    func fetchVenuesList(userLocation: UserLocation, completion: @escaping (Result<[Venue], Error>) -> Void) {
        let requestURL = APIEndPoints.getVenuesURLRequest(userLocation: userLocation)
        client.get(from: requestURL) { result in
            switch result{
            case let .success((data,urlResponse)):
                completion(VenueItemsMapper.map(data, urlResponse))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    
    
}
