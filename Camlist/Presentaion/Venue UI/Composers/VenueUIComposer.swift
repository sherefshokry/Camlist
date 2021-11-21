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
        
//        viewModel.onShowErrorMessage = { [weak venueController] alertMessage in
//          //  venueController?.
//        }
        
        viewModel.onVenueLoadedWithError = { [weak venueController] error in
            venueController?.venueItems = []
            if case NetworkError.invalidData = error {
                venueController?.displayErrorView(with: "No Data Found !!")
            }else{
                venueController?.displayErrorView(with: "Something Went Wrong !!")
            }
        }
        
        viewModel.onVenueUpdated = adaptVenueToCellController(forwardingTo: venueController, imageLoaderUseCase: fetchVenueImageUseCase)
        
        return venueController
    }
    
    
    private static func adaptVenueToCellController(forwardingTo controller: VenueViewController,imageLoaderUseCase: FetchVenueImageUseCase) -> (([Venue]) -> Void) {
        
        return {[weak controller] venueItems in
            controller?.venueItems = venueItems.map {
                let viewModel = VenueCellViewModel(model: $0, useCase: imageLoaderUseCase)
                return VenueCellController(viewModel: viewModel)
            }
        }
    }
    
}



