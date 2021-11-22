//
//  VenueItemsMapper.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

internal final class VenueItemsMapper {
    
    private struct Root : Codable {
        let results: [Item]
        
        
        var venue: [Venue]{
            return results.map{ $0.item }
        }
        
        enum CodingKeys: String, CodingKey {
          case results
        }
        
    }
    
    private struct Item : Codable {
        let fsqID, name: String
        let location: ItemLocation
        
        enum CodingKeys: String, CodingKey {
          case fsqID = "fsq_id"
          case name , location
        }
        
        var item: Venue {
            return Venue(id: fsqID, name: name, location: location.item)
        }
        
    }
    
    private struct ItemLocation : Codable {
        let address: String?
       
        enum CodingKeys: String, CodingKey {
          case address
        }
        
        
        var item: VenueLocation {
            return VenueLocation(address: address)
        }
    }
    
    private static var OK_200 : Int { return  200 }
    
    internal static func map(_ data: Data,_ response: HTTPURLResponse) -> Result<[Venue], Error> {
        guard response.statusCode == OK_200 ,  let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(NetworkError.invalidData)
        }
        return root.venue.isEmpty ? .failure(NetworkError.invalidData) : .success(root.venue)
    }
    
    
}
