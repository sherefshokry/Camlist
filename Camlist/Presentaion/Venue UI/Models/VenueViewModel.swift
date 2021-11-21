//
//  VenueViewModel.swift
//  Camlist
//
//  Created by SherifShokry on 19/11/2021.
//

import Foundation
import CoreLocation

final class VenueViewModel{
    typealias Observer<T> = (T) -> Void
    let useCase: FetchVenueUseCase
    
    var onVenueUpdated: Observer<[Venue]>?
    var onVenueLoadedWithError: Observer<Error>?
    var onVenueLoading: Observer<Bool>?
    var onShowErrorMessage: Observer<String>?
    
    init(useCase: FetchVenueUseCase){
        self.useCase = useCase
    }
    
    func loadVenues(){
        
        LocationManager.shared.getLocation {[weak self] (location:CLLocation?, error:NSError?) in
            
            if let error = error {
                self?.onShowErrorMessage?(error.localizedDescription)
                return
            }
            
            guard let location = location else {
                self?.onShowErrorMessage?("Unable to fetch location")
                 return
            }
            let userLocation = UserLocation(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            self?.onVenueLoading?(true)
            self?.useCase.execute(userLocation: userLocation) { [weak self] result in
                guard let self = self else{ return }
                switch result{
                case let .success(venue):
                    self.onVenueUpdated?(venue)
                case let .failure(error):
                    self.onVenueLoadedWithError?(error)
                }
                self.onVenueLoading?(false)
            }
            
            
            
        }
        
    }
    
}
