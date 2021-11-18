//
//  RemoteVenueLoader.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation


public enum NetworkError : Swift.Error {
    case connectivity
    case invalidData
}

public final class RemoteVenueLoader: VenuesRepository{
    
    private let client : HTTPClient
    
    public init(client : HTTPClient){
        self.client = client
    }
    
    func fetchVenuesList(userLocation: UserLocation, completion: @escaping (Result<[Venue], Error>) -> Void) {
        let requestURL = APIEndPoints.getVenuesURLRequest(userLocation: userLocation)
        client.get(from: requestURL) {[weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data,response)):
                completion(VenueItemsMapper.map(data,response))
            case .failure:
                completion(.failure(NetworkError.connectivity))
            }
        }
    }
    
}
