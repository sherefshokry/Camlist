//
//  VenueUIComposer.swift
//  Camlist
//
//  Created by SherifShokry on 19/11/2021.
//

import Foundation

final class VenueUIComposer{
    private init() {}
    
    public static func venueComposedWith(fetchVenueUseCase: FetchVenueUseCase, fetchVenueImageUseCase: FetchVenueImageUseCase) -> VenueViewController {
        let viewModel = VenueViewModel(useCase: fetchVenueUseCase)
        let venueUpdateViewController = VenueUpdateViewController(viewModel: viewModel)
        let venueController = VenueViewController.instantiateViewController()
        venueController.venueUpdateController = venueUpdateViewController
        
        viewModel.onVenueLoadedWithError = { [weak venueController] error in
            venueController?.venueItems = []
            venueController?.hasError = true
        }
        
        viewModel.onVenueUpdated = adaptVenueToCellController(forwardingTo: venueController, imageLoaderUseCase: fetchVenueImageUseCase)
        
        return venueController
    }
    
    
    private static func adaptVenueToCellController(forwardingTo controller: VenueViewController,imageLoaderUseCase: FetchVenueImageUseCase) -> (([Venue]) -> Void) {
        
        return {[weak controller] venueItems in
            controller?.venueItems = venueItems.map {
                VenueCellController(model: $0,useCase: imageLoaderUseCase)
            }
            
        }
        
        
    }
    
    
    
}
