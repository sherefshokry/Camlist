//
//  RemoteVenueImageLoader.swift
//  Camlist
//
//  Created by SherifShokry on 20/11/2021.
//

import Foundation


public final class RemoteVenueImageLoader: VenueImageRepository{
    
    private let client : HTTPClient
    
    public init(client : HTTPClient){
        self.client = client
    }
    
    
    func fetchVenueImage(venueId: String, completion: @escaping (Result<[VenueImage], Error>) -> Void) -> HTTPClientTask {
        let urlRequest = APIEndPoints.getVenueImageURLRequest(venueID: venueId)
        let task = client.get(from: urlRequest) {[weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data,response)):
                completion(VenueImageMapper.map(data,response))
            case .failure:
                completion(.failure(NetworkError.connectivity))
            }
        }
        
        return task
    }
    
    
    
}
