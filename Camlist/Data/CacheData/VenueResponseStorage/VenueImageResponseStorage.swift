//
//  VenueImageResponseStorage.swift
//  Camlist
//
//  Created by SherifShokry on 22/11/2021.
//

import Foundation


protocol VenueImageResponseStorage {
    func getResponse(with venueId: String,completion: @escaping (Result<VenueImage?, CoreDataStorageError>) -> Void)
    func saveResponse(with venueImage: VenueImage,for venueId: String)
}
