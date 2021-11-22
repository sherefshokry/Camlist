//
//  MainAppController.swift
//  Camlist
//
//  Created by SherifShokry on 22/11/2021.
//

import Foundation


final class MainAppController{
    
    // MARK: - App DIContainer
    func makeVenueScene() -> VenueViewController {
        let client = URLSessionHTTPClient()
        let venueResponseStorage = CoreDataVenueResponseStorage()
        let remoteVenueLoader = RemoteVenueLoader(client: client, venueResponseStorage: venueResponseStorage)
        let localVenueLoader = LocalVenueLoader(venueResponseStorage: venueResponseStorage)
        let venueRepo = VenueRepoWithFallBack(primary: remoteVenueLoader, fallback: localVenueLoader)
        let fetchVenueUseCase = DefaultFetchVenueUseCase(venueRepository: venueRepo)
        let venueImageResponseStorage = CoreDataVenueImageResponseStorage()
        let venueImageRepo = RemoteVenueImageLoader(client: client, venueResponseStorage: venueImageResponseStorage)
        let fetchVenueImageUseCase = DefaultFetchVenueImageUseCase(venueRepository: venueImageRepo)
        return VenueUIComposer.venueComposedWith(fetchVenueUseCase: fetchVenueUseCase, fetchVenueImageUseCase: fetchVenueImageUseCase)
    }
    
}
