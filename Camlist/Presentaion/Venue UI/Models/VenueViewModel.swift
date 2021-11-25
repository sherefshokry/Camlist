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
    weak var useCase: FetchVenueUseCase?
    
    var onVenueUpdated: Observer<[Venue]>?
    var onVenueLoadedWithError: Observer<Error>?
    var onVenueLoading: Observer<Bool>?
    
    init(useCase: FetchVenueUseCase){
        
        self.useCase = useCase
        
    }
    
    func loadVenues(){
 
        onVenueLoading?(true)
        
        useCase?.execute() {[weak self]  result in
            
            switch result{
            case let .success(venue):
                self?.onVenueUpdated?(venue)
            case let .failure(error):
                self?.onVenueLoadedWithError?(error)
            }
            self?.onVenueLoading?(false)
        }
    }
    
 
    
}

