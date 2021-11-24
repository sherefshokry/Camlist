//
//  RemoteVenueImageLoader.swift
//  Camlist
//
//  Created by SherifShokry on 20/11/2021.
//

import Foundation


public final class RemoteVenueImageLoader: VenueImageRepository{
   
    public let client : HTTPClient
    public let venueResponseStorage: VenueImageResponseStorage?
    var urlRequest: URLRequest
    var venueId: String
    
    public init(client : HTTPClient,venueResponseStorage: VenueImageResponseStorage?,urlRequest: URLRequest,venueId: String){
        self.client = client
        self.venueResponseStorage = venueResponseStorage
        self.urlRequest = urlRequest
        self.venueId = venueId
    }
    
    public func fetchVenueImage(cached: @escaping (VenueImage) -> Void, completion: @escaping (Result<VenueImage, Error>) -> Void)  {
    
        venueResponseStorage?.getResponse(with: venueId) {[weak self] cachedResult in
            if case let .success(cachedImage) =  cachedResult{
                cached(cachedImage!)
            }
        
            self?.client.get(from: self!.urlRequest) {[weak self] result in
                guard self != nil else { return }
                switch result {
                case let .success((data,response)):
                    let mappedResponseData = VenueImageMapper.map(data,response)
                    if case let .success(venueImage) = mappedResponseData {
                        
                        self?.venueResponseStorage?.saveResponse(with: venueImage, for: self?.venueId ?? "")
                    }
                    completion(mappedResponseData)
                case .failure:
                    completion(.failure(NetworkError.connectivity))
                }
            }
           
        }
        
    }
    
}
