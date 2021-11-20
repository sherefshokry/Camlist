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
        
//        enum CodingKeys: String, CodingKey {
//               case results
//               case venue
//           }
    }
    
    private struct Item : Codable {
        let fsq_id, name: String
        let location: ItemLocation
        
        var item: Venue {
            return Venue(id: fsq_id, name: name, location: location.item)
        }
        
//        enum CodingKeys: String, CodingKey {
//               case fsqID = "fsq_id"
//               case location,name,item
//           }
    }
    
    private struct ItemLocation : Codable {
        let address: String?
        
        var item: VenueLocation {
            return VenueLocation(address: address)
        }
        
//        enum CodingKeys: String, CodingKey {
//               case address
//        }
    }
    
    private static var OK_200 : Int { return  200 }
    
    internal static func map(_ data: Data,_ response: HTTPURLResponse) -> Result<[Venue], Error> {
        guard response.statusCode == OK_200 ,  let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(NetworkError.invalidData)
        }
        return root.venue.isEmpty ? .failure(NetworkError.invalidData) : .success(root.venue)
    }
    
    
}
