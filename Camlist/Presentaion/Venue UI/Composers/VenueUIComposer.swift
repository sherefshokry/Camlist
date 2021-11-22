//
//  VenueUIComposer.swift
//  Camlist
//
//  Created by SherifShokry on 19/11/2021.
//

import Foundation

final class VenueUIComposer{
    private init() {}
    
    public static func venueComposedWith(fetchVenueUseCase: FetchVenueUseCase,fetchVenueImageUseCase: FetchVenueImageUseCase) -> VenueViewController {
        let viewModel = VenueViewModel(useCase: fetchVenueUseCase)
        let venueUpdateViewController = VenueUpdateViewController(viewModel: viewModel)
        let venueController = VenueViewController.instantiateViewController()
        venueController.venueUpdateController = venueUpdateViewController
        
        
        venueUpdateViewController.onShowErrorMessage = { [weak venueController] alertMessage in
            venueController?.showMessage(alertMessage)
        }
        
        venueController.reloadVenueList = {
            venueController.hideErrorView()
            venueUpdateViewController.loadVenueData()
        }
        
        viewModel.onVenueLoadedWithError = { [weak venueController] error in
            venueController?.venueItems = []
            if case NetworkError.invalidData = error {
                venueController?.displayErrorView(with: Constants.Strings.NO_DATA)
            }else{
                venueController?.displayErrorView(with: Constants.Strings.SOMETHING_WRONG)
            }
        }
        
        viewModel.onVenueUpdated = adaptVenueToCellController(forwardingTo: venueController, imageLoaderUseCase: fetchVenueImageUseCase)
        
        return venueController
    }
    

    private static func adaptVenueToCellController(forwardingTo controller: VenueViewController,imageLoaderUseCase: FetchVenueImageUseCase) -> (([Venue]) -> Void) {
        controller.venueItems = []
        return {[weak controller] venueItems in
            controller?.venueItems = venueItems.map {
                let viewModel = VenueCellViewModel(model: $0, useCase: imageLoaderUseCase)
                return VenueCellController(viewModel: viewModel)
            }
        }
    }
    
}



