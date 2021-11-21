//
//  UpdateVenueViewController.swift
//  Camlist
//
//  Created by SherifShokry on 19/11/2021.
//

import Foundation
import UIKit
import CoreLocation

class VenueUpdateViewController {
    
    private(set) lazy var view: UIActivityIndicatorView = binded(UIActivityIndicatorView())
    private let viewModel: VenueViewModel
    
    
    init(viewModel: VenueViewModel) {
        self.viewModel = viewModel
    }
    
    var onVenueUpdated: (([Venue]) -> Void)?
    
    func loadVenueData(){
        LocationManager.shared.getLocation {[weak self] (location:CLLocation?, error:NSError?) in
            
            if let error = error {
                //   self?.onShowErrorMessage?(error.localizedDescription)
                return
            }
            
            guard let location = location else {
                //   self?.onShowErrorMessage?("Unable to fetch location")
                return
            }
            
            let userLocation = UserLocation(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            self?.saveUserCurrentLocation(userLocation: userLocation)
            
            self?.viewModel.loadVenues()
        }
    }
    
    func saveUserCurrentLocation(userLocation: UserLocation){
        if let value = try? JSONEncoder().encode(userLocation) {
            UserDefaults.standard.set(value, forKey: "userLocation")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    func binded(_ view: UIActivityIndicatorView) -> UIActivityIndicatorView {
        
        viewModel.onVenueLoading = {[weak view] isLoading in
            DispatchQueue.main.async { [weak view] in
                if (isLoading){
                    view?.isHidden = false
                    view?.startAnimating()
                }else{
                    view?.isHidden = true
                    view?.stopAnimating()
                }
            }
            
        }
        return view
    }
    
    
}
