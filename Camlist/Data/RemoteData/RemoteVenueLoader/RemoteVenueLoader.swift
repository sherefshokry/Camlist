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

struct RemoteVenueLoader: VenueRepository{
    
    let client : HTTPClient
    let venueResponseStorage: VenueResponseStorage
    

    func fetchVenuesList(completion: @escaping (Result<[Venue], Error>) -> Void) {
        let userLocation = loadUserLocation() ?? defaultLocation()
        let urlRequest = APIEndPoints.getVenuesURLRequest(userLocation: userLocation)
        
        client.get(from: urlRequest) { result in
            switch result {
            case let .success((data,response)):
                let mappedData = VenueItemsMapper.map(data,response)
                if case let .success(venueItems) = mappedData {
                    venueResponseStorage.saveResponse(with: venueItems)
                }
                completion(mappedData)
            case .failure:
                
                
                completion(.failure(NetworkError.connectivity))
            }
        }
    }
     
    
    func loadUserLocation() -> UserLocation? {
        if let value = UserDefaults.standard.value(forKey: Constants.DefaultCaching.USER_LOCATION) as? Data {
            if let user = try? JSONDecoder().decode(UserLocation.self, from: value ) {
                return user
            }
        }
        return nil
    }
    
    func defaultLocation() -> UserLocation{
        return UserLocation(lat: 30.0511, lng: 31.2126)
    }
    
    
}
