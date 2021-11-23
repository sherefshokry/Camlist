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

public class RemoteVenueLoader: VenueRepository{
  
    let client : HTTPClient
    let venueResponseStorage: VenueResponseStorage?
    var urlRequest: URLRequest
    
    public init(client: HTTPClient,venueResponseStorage: VenueResponseStorage?,urlRequest: URLRequest) {
        self.client = client
        self.venueResponseStorage = venueResponseStorage
        self.urlRequest = urlRequest
    }

   public func fetchVenueList(completion: @escaping (Result<[Venue], Error>) -> Void) {
        client.get(from: urlRequest) {[weak self] result in
            switch result {
            case let .success((data,response)):
                let mappedResponseData = VenueItemsMapper.map(data,response)
                if case let .success(venueItems) = mappedResponseData {
                    self?.venueResponseStorage?.saveResponse(with: venueItems)
                }
                completion(mappedResponseData)
            case .failure:
                completion(.failure(NetworkError.connectivity))
            }
        }
    }

}
