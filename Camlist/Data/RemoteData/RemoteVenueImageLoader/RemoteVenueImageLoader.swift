//
//  RemoteVenueImageLoader.swift
//  Camlist
//
//  Created by SherifShokry on 20/11/2021.
//

import Foundation


public final class RemoteVenueImageLoader: VenueImageRepository{
   
    private let client : HTTPClient
    private let venueResponseStorage: VenueImageResponseStorage
    
    init(client : HTTPClient,venueResponseStorage: VenueImageResponseStorage){
        self.client = client
        self.venueResponseStorage = venueResponseStorage
    }
    
    func fetchVenueImage(venueId: String, cached: @escaping (VenueImage) -> Void, completion: @escaping (Result<VenueImage, Error>) -> Void) -> HTTPClientTask? {
        let urlRequest = APIEndPoints.getVenueImageURLRequest(venueID: venueId)
        var task: HTTPClientTask?
        
        venueResponseStorage.getResponse(with: venueId) {[weak self] cachedResult in
            if case let .success(cachedImage) =  cachedResult{
                cached(cachedImage!)
            }
            
            task = self?.client.get(from: urlRequest) {[weak self] result in
                guard self != nil else { return }
                switch result {
                case let .success((data,response)):
                    let mappedResponseData = VenueImageMapper.map(data,response)
                    if case let .success(venueImage) = mappedResponseData {
                        
                        self?.venueResponseStorage.saveResponse(with: venueImage, for: venueId)
                    }
                    completion(mappedResponseData)
                case .failure:
                    completion(.failure(NetworkError.connectivity))
                }
            }
           
        }
        return task
    }
    
}
