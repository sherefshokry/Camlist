//
//  VenueItemsMapper.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

internal final class VenueItemsMapper {
    
    private struct Root : Decodable {
        let response: Response
    }
    
    private struct Response : Decodable {
        let venues: [Item]
        let confident: Bool
        
        var venue: [Venue]{
            return venues.map{ $0.item }
        }
    }
    
    private struct Item : Decodable {
        let id, name: String
        let location: ItemLocation
        
        var item: Venue {
            return Venue(id: id, name: name, location: location.item)
        }
    }
    
    private struct ItemLocation : Decodable {
        let lat, lng: Double
        let distance: Int
        let city, state: String?
        let country: String
        let formattedAddress: [String]
        let address: String?
        
        var item: VenueLocation {
            return VenueLocation(lat: lat, lng: lng, distance: distance, city: city, state: state, country: country, formattedAddress: formattedAddress, address: address)
        }
    }
    
    private static var OK_200 : Int { return  200 }
    
    internal static func map(_ data: Data,_ response: HTTPURLResponse) -> Result<[Venue], Error> {
        guard response.statusCode == OK_200 ,  let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(NetworkError.invalidData)
        }
        
        return .success(root.response.venue)
    }
    
    
}
