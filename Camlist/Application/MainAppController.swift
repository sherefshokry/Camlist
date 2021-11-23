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
        
        let userLocation = defaultLocation()
        let urlRequest = APIEndPoints.getVenuesURLRequest(userLocation: userLocation)
        let remoteVenueLoader = RemoteVenueLoader(client: client, venueResponseStorage: venueResponseStorage, urlRequest: urlRequest)
        
        NotificationCenter.default.addObserver(forName:NSNotification.Name(Constants.CustomNotification.UPDATE_LOCATION_NOTIFICATION), object: nil, queue: nil) { notification in
            
            if let dict = notification.userInfo as NSDictionary? {
                if let updatedUserLocation = dict["location"] as? UserLocation{
                    remoteVenueLoader.urlRequest = APIEndPoints.getVenuesURLRequest(userLocation: updatedUserLocation)
                }
            }
        }
        let localVenueLoader = LocalVenueLoader(venueResponseStorage: venueResponseStorage)
        let venueRepo = VenueRepoWithFallBack(primary: remoteVenueLoader, fallback: localVenueLoader)
        let fetchVenueUseCase = DefaultFetchVenueUseCase(venueRepository: venueRepo)
        let venueImageResponseStorage = CoreDataVenueImageResponseStorage()
        let venueImageRepo = RemoteVenueImageLoader(client: client, venueResponseStorage: venueImageResponseStorage)
        let fetchVenueImageUseCase = DefaultFetchVenueImageUseCase(venueRepository: venueImageRepo)
        return VenueUIComposer.venueComposedWith(fetchVenueUseCase: fetchVenueUseCase, fetchVenueImageUseCase: fetchVenueImageUseCase)
    }

    
    private func defaultLocation() -> UserLocation{
        return UserLocation(lat: 30.0511, lng: 31.2126)
    }
    
    
    
}
