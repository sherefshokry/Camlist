//
//  VenueUIComposer.swift
//  Camlist
//
//  Created by SherifShokry on 19/11/2021.
//

import Foundation

final class VenueUIComposer{
    private init() {}
    
    public static func venueComposedWith(fetchVenueUseCase: FetchVenueUseCase) -> VenueViewController {
        let viewModel = VenueViewModel(useCase: fetchVenueUseCase)
        let venueUpdateViewController = VenueUpdateViewController(viewModel: viewModel)
        let venueController = VenueViewController.instantiateViewController()
        venueController.venueUpdateController = venueUpdateViewController
        
        viewModel.onVenueLoadedWithError = { [weak venueController] error in
            venueController?.venueItems = []
            venueController?.hasError = true
        }
        
        viewModel.onVenueUpdated = { [weak venueController] venue in
            venueController?.venueItems = venue
            venueController?.hasError = false
        }
        
        return venueController
    }
    
    
}
