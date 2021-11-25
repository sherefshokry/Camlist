//
//  MainAppController.swift
//  Camlist
//
//  Created by SherifShokry on 22/11/2021.
//

import Foundation


final class MainAppController{
    
    var fetchVenueUseCase: FetchVenueUseCase?
    var fetchVenueImageUseCase: FetchVenueImageUseCase?
    
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
        fetchVenueUseCase = DefaultFetchVenueUseCase(venueRepository: venueRepo)
        let venueImageResponseStorage = CoreDataVenueImageResponseStorage()
        let imageUrlRequest = APIEndPoints.getVenueImageURLRequest(venueID: "-1")
        let venueImageRepo = RemoteVenueImageLoader(client: client, venueResponseStorage: venueImageResponseStorage, urlRequest: imageUrlRequest,venueId: "-1")
        
        NotificationCenter.default.addObserver(forName:NSNotification.Name(Constants.CustomNotification.UPDATE_VENUE_ID), object: nil, queue: nil) { notification in
            if let dict = notification.userInfo as NSDictionary? {
                if let updatedVenueID = dict["venueID"] as? String{
                    venueImageRepo.urlRequest = APIEndPoints.getVenueImageURLRequest(venueID: updatedVenueID)
                    venueImageRepo.venueId = updatedVenueID
                }
            }
        }
    
        fetchVenueImageUseCase = DefaultFetchVenueImageUseCase(venueRepository: venueImageRepo)
        return VenueUIComposer.venueComposedWith(fetchVenueUseCase: fetchVenueUseCase, fetchVenueImageUseCase: fetchVenueImageUseCase)
    }

    
    private func defaultLocation() -> UserLocation{
        return UserLocation(lat: 30.0511, lng: 31.2126)
    }
    

}
