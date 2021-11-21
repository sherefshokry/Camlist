//
//  LocalVenueLoader.swift
//  Camlist
//
//  Created by SherifShokry on 21/11/2021.
//

import Foundation


struct LocalVenueLoader: VenueRepository {
    
    private let venueResponseStorage: VenueResponseStorage
    
    init(venueResponseStorage: VenueResponseStorage) {
        self.venueResponseStorage = venueResponseStorage
    }
    
    private struct UnExpectedValuesRepresntation: Error{}
    
    func fetchVenuesList(completion: @escaping (Result<[Venue], Error>) -> Void) {
        
        venueResponseStorage.getResponse { result in
            switch result{
            case let .success(venueList):
                
                if ((venueList?.isEmpty) != nil) {
                    completion(.failure(UnExpectedValuesRepresntation()))
                }else{
                    completion(.success(venueList ?? [Venue]()))
                }
                
            case let .failure(coreDataError):
                
                completion(.failure(coreDataError))
                
            }
        }
    }
    
    
}
