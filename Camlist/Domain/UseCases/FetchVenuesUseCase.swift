//
//  LoadingVenuesWithCurrentUserLocation.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation

protocol FetchVenuesUseCase {
    func execute(userLocation: UserLocation, completion: @escaping (Result<[Venue],Error>) -> Void)
}

public struct UserLocation {
    let lat: Double
    let lng: Double
}
