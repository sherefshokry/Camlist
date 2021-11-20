//
//  VenueCellViewModel.swift
//  Camlist
//
//  Created by SherifShokry on 20/11/2021.
//

import Foundation

class VenueCellViewModel{
    typealias Observer<T> = (T) -> Void
    
    private var task: HTTPClientTask?
    private var model: Venue
    private var useCase: FetchVenueImageUseCase
    
    internal init(model: Venue, useCase: FetchVenueImageUseCase) {
        self.model = model
        self.useCase = useCase
    }
    
    
    var venueName: String? {
        return model.name
    }
    
    var venueAddress: String? {
        return model.location.address
    }
    
    var onImageLoad: Observer<URL>?
    var onImageFailedToLoad: Observer<Error>?
    
    
    func loadImageData(){
       task = useCase.execute(venueId: model.id) {[weak self] result in
            self?.handle(result: result)
        }
    }
    
    private struct EmptyValuesRepresentation: Error {}
    
    func handle(result: Result<[VenueImage],Error>) {
        
        switch result{
        case let .success(venueItems):
            if !venueItems.isEmpty{
                onImageLoad?(prepareImageUrl(with: venueItems[0]))
            }else{
                onImageFailedToLoad?(EmptyValuesRepresentation())
            }
        case let .failure(error):
            onImageFailedToLoad?(error)
        }
        
        
    }
    

    func cancelImageDataLoad(){
        task?.cancel()
    }
    
    private func prepareImageUrl(with venue: VenueImage) -> URL {
        let imageURL = venue.prefix + "\(venue.width)" + venue.suffix
        return URL(string: imageURL)!
    }
    
    
    
}
