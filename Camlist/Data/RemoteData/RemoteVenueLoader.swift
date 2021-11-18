//
//  RemoteVenueLoader.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

public final class RemoteVenueLoader: VenuesRepository{
    
    private let client : HTTPClient
    private let url : URL
    
    
    public init(url: URL,client : HTTPClient){
           self.client = client
           self.url = url
    }
    
    func fetchVenuesList(userLocation: UserLocation, limit: Int, completion: @escaping (Result<[Venue], Error>) -> Void) {
        
    }
    
   
//
//    public enum Error : Swift.Error {
//        case connectivity
//        case invalidData
//    }
//
//
    
    
//    func fetchVenuesList(userLocation: UserLocation, limit: Int, completion: @escaping (Result<[Venue], Error>) -> Void) {
////        client.get(from: url){[weak self] result in
////            guard self != nil else { return }
//////            switch result {
//////            case let .success(data,response):
//////               // print(self)
//////             //  completion(FeedItemsMapper.map(data, response))
//////            case .failure:
//////               // completion(.failure(Error.connectivity))
//////            }
////        }
//    }
    
    
    
}
