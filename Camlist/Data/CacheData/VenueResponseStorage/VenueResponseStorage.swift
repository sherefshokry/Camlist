//
//  VenueResponseStorage.swift
//  Camlist
//
//  Created by SherifShokry on 21/11/2021.
//

import Foundation


public protocol VenueResponseStorage {
     func getResponse(completion: @escaping (Result<[Venue]?, CoreDataStorageError>) -> Void)
     func saveResponse(with venueList: [Venue])
}
