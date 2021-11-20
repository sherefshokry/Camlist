//
//  UpdateVenueViewController.swift
//  Camlist
//
//  Created by SherifShokry on 19/11/2021.
//

import Foundation
import UIKit


class VenueUpdateViewController {
    
    private(set) lazy var view: UIActivityIndicatorView = binded(UIActivityIndicatorView())
    private let viewModel: VenueViewModel
    

    init(viewModel: VenueViewModel) {
        self.viewModel = viewModel
    }
    
    var onVenueUpdated: (([Venue]) -> Void)?
    
    func loadVenueData(){
        viewModel.loadVenues()
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
