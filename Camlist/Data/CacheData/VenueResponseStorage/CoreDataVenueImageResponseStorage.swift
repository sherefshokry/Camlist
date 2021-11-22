//
//  CoreDataVenueImageResponseStorage.swift
//  Camlist
//
//  Created by SherifShokry on 22/11/2021.
//

import Foundation

import Foundation
import CoreData

final class CoreDataVenueImageResponseStorage {
    
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    // MARK: - Private
    
    private func fetchRequest(with venueId: String) -> NSFetchRequest<VenueEntity> {
        let request: NSFetchRequest<VenueEntity> = VenueEntity.fetchRequest()
        
        request.predicate = NSPredicate(format: "%K = %@", #keyPath(VenueEntity.venueID), venueId)
        
        return request
    }
    
    private func deleteResponse(with venueId: String,in context: NSManagedObjectContext) -> NSFetchRequest<VenueEntity> {
        let request = fetchRequest(with: venueId)
        
        do {
            if let result = try context.fetch(request).first {
                context.delete(result.venueImage ?? VenueImageEntity())
            }
        } catch {
            print(error)
        }
        
        return request
    }
}

extension CoreDataVenueImageResponseStorage: VenueImageResponseStorage {
    
    func getResponse(with venueId: String,completion: @escaping (Result<VenueImage?, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(with: venueId)
                
                let requestEntity = try context.fetch(fetchRequest).first
                
                let venueImage: VenueImage = VenueImage(id: requestEntity?.venueImage?.imageID ?? "-1", prefix: requestEntity?.venueImage?.prefix ?? "" , suffix: requestEntity?.venueImage?.suffix ?? "", width: Int(requestEntity?.venueImage?.width ?? 100), height: Int(requestEntity?.venueImage?.height ?? 100))
                
                completion(.success(venueImage))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func saveResponse(with venueImage: VenueImage,for venueId: String) {
        coreDataStorage.performBackgroundTask { context in
            
            let request = self.deleteResponse(with: venueId,in: context)
            
            do {
                if let result = try context.fetch(request).first {
                    let venueImageEntity: VenueImageEntity = .init(context: context)
                    venueImageEntity.imageID = venueImage.id
                    venueImageEntity.suffix = venueImage.suffix
                    venueImageEntity.prefix = venueImage.prefix
                    venueImageEntity.height = Int32(venueImage.height)
                    venueImageEntity.width = Int32(venueImage.width)
                    result.venueImage = venueImageEntity
                    try context.save()
                }
            } catch {
                debugPrint("Can not save venue response")
            }
       }
    }
    
    
}

