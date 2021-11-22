//
//  UpdateVenueViewController.swift
//  Camlist
//
//  Created by SherifShokry on 19/11/2021.
//

import Foundation
import UIKit
import CoreLocation
import KVNProgress

class VenueUpdateViewController {
    
    var view: UIView = UIView()
    private let viewModel: VenueViewModel
    
    
    init(viewModel: VenueViewModel) {
        self.viewModel = viewModel
    }
    
    var onVenueUpdated: (([Venue]) -> Void)?
    var onShowErrorMessage: ((String) -> Void)?
    
    func setLoadingView(with view:UIView){
       bind(view)
    }
    
    func loadVenueData(){
        LocationManager.shared.getLocation {[weak self] (location:CLLocation?, error:NSError?) in
            
            if let error = error {
                self?.onShowErrorMessage?(error.localizedDescription)
                return
            }

            guard let location = location else {
                self?.onShowErrorMessage?(Constants.Strings.UNABLE_FETCH_LOCATION)
                return
            }
            
            let userLocation = UserLocation(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            self?.saveUserCurrentLocation(userLocation: userLocation)
            
            self?.viewModel.loadVenues()
        }
    }
    
    func saveUserCurrentLocation(userLocation: UserLocation){
        if let value = try? JSONEncoder().encode(userLocation) {
            UserDefaults.standard.set(value, forKey: Constants.DefaultCaching.USER_LOCATION)
            UserDefaults.standard.synchronize()
        }
    }
    
    
    func bind(_ loadedView: UIView) {
        viewModel.onVenueLoading = { isLoading in
            DispatchQueue.main.async {[weak loadedView] in
                if (isLoading){
                    KVNProgress.show(withStatus: Constants.Strings.WAIT, on: loadedView!)
                }else{
                    KVNProgress.dismiss()
                    self.setLoadingView(with: UIView())
                }
            }
            
        }
    }
    
    
}
