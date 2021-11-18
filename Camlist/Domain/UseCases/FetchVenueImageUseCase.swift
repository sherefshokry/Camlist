//
//  FetchVenueImageUseCase.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation


protocol FetchVenueImageUseCase {
    func execute(venueId: String, completion: @escaping (Result<VenueImage,Error>) -> Void)
}
