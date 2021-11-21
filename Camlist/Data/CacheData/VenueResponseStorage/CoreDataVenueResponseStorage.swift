//
//  CoreDataVenueResponseStorage.swift
//  Camlist
//
//  Created by SherifShokry on 21/11/2021.
//

import Foundation
import CoreData

final class CoreDataVenueResponseStorage {
    
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    // MARK: - Private
    
    private func fetchRequest() -> NSFetchRequest<VenueEntity> {
        let request: NSFetchRequest = VenueEntity.fetchRequest()
        return request
    }
    
    private func deleteResponse(in context: NSManagedObjectContext) {
        let request = fetchRequest()
        
        let result = try? context.fetch(request)
        
        result?.forEach { entity in
            context.delete(entity)
        }
        
        
        
    }
}

extension CoreDataVenueResponseStorage: VenueResponseStorage {
    
    func getResponse(completion: @escaping (Result<[Venue]?, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest()
                let requestEntity = try context.fetch(fetchRequest)
                
                var venueItems: [Venue] = []
                
                requestEntity.forEach { entity in
                    let location = VenueLocation(address: entity.location?.address)
                    venueItems.append(Venue(id: entity.id ?? "", name: entity.name ?? "", location: location))
                }
                
                completion(.success(venueItems))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func saveResponse(with venueList: [Venue]) {
        coreDataStorage.performBackgroundTask { context in
            do{
                self.deleteResponse(in: context)
                
                
                venueList.forEach { venue in
                    let entity : VenueEntity = .init(context: context)
                    let locationEntity: LocationEntity = .init(context: context)
                    locationEntity.address = venue.location.address
                    entity.id = venue.id
                    entity.name = venue.name
                    entity.location = locationEntity
                }
                
                try context.save()
            }catch{
                debugPrint("Can not save venue response")
            }
            
        }
    }
    
    
}

