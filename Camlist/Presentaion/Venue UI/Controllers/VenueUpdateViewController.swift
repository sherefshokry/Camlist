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
    private let locationManager: LocationManagerService
    
    init(viewModel: VenueViewModel,locationManager: LocationManagerService = LocationManager.shared) {
        self.viewModel = viewModel
        self.locationManager = locationManager
    }
    
    var onVenueUpdated: (([Venue]) -> Void)?
    var onShowErrorMessage: ((String) -> Void)?
    
    func setLoadingView(with view:UIView){
       bind(view)
    }
    
    func loadVenueData(){
        
        locationManager.getLocation {[weak self] (location:CLLocation?, error:NSError?) in
            if let error = error {
                print(error)
                return
            }

            guard let location = location else {
                self?.onShowErrorMessage?(Constants.Strings.UNABLE_FETCH_LOCATION)
                return
            }

            let userLocation = UserLocation(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            NotificationCenter.default.post(name: Notification.Name(Constants.CustomNotification.UPDATE_LOCATION_NOTIFICATION), object: nil, userInfo: ["location" : userLocation])

            self?.viewModel.loadVenues()
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
