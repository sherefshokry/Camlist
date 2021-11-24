//
//  VenueImageMapper.swift
//  Camlist
//
//  Created by SherifShokry on 20/11/2021.
//

import Foundation


internal final class VenueImageMapper{
    
    
    struct VenueImageItem: Codable {
        let id: String
        let prefix: String
        let suffix: String
        let width:  Int
        let height: Int
        
        
        var item: VenueImage {
            return VenueImage(id: id, prefix: prefix, suffix: suffix, width: width, height: height)
        }
    }
    
    
    
    
    private static var OK_200 : Int { return  200 }
    
    internal static func map(_ data: Data,_ response: HTTPURLResponse) -> Result<VenueImage, Error> {
        guard response.statusCode == OK_200 ,  let root = try? JSONDecoder().decode([VenueImageItem].self, from: data) else {
            
            return .failure(NetworkError.invalidData)
        }
        let venueImages = root.map{ $0.item }
        
        return venueImages.isEmpty ? .failure(NetworkError.invalidData) : .success(venueImages[0])
    }
    
}
