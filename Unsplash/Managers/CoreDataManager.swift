//
//  CoreDataManager.swift
//  Unsplash
//
//  Created by Ярослав Акулов on 08.10.2022.
//

import CoreData
import Foundation

final class CoreDataManager {
   
    // MARK: - Core Data stack
    static let shared = CoreDataManager()
    private lazy var context = persistentContainer.viewContext
    private let photoEntityName = "PhotoEntity"
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Unsplash")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getPhotos() -> [Photo] {
        let fetchRequest: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()
        guard let entityData = try? CoreDataManager.shared.context.fetch(fetchRequest) else { return [] }
        var photos: [Photo] = []
        entityData.forEach { entity in
            photos.append(photoFromEntity(entity))
        }
        return photos
    }
    
    func save(_ photo: Photo) {
        guard let entity = NSEntityDescription.entity(forEntityName: photoEntityName, in: context),
              let object = NSManagedObject(entity: entity, insertInto: context) as? PhotoEntity else {
                  return
              }
        object.id = photo.id
        object.createdDate = photo.createdDate
        object.downloadsCount = Int64(photo.downloadsCount ?? 0)
        object.location = photo.location?.name
        object.userName = photo.user?.name
        object.url = photo.urls?.small
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func isPhotoExist(with id: String) -> Bool {
        let predicateRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: photoEntityName)
        predicateRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            if let result = try CoreDataManager.shared.context.fetch(predicateRequest) as? [PhotoEntity],
               !result.isEmpty {
                return true
            }
            return false
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func delete(photo: Photo) {
        guard let id = photo.id else { return }
        let predicateRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: photoEntityName)
        predicateRequest.predicate = NSPredicate(format: "id == %@", id)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: predicateRequest)
        do {
            try CoreDataManager.shared.context.execute(deleteRequest)
            try? context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func photoFromEntity(_ entity: PhotoEntity) -> Photo {
        let photo = Photo(id: entity.id,
                          createdDate: entity.createdDate,
                          downloadsCount: Int(entity.downloadsCount),
                          location: Location(name: entity.location),
                          user: User(name: entity.userName),
                          urls: Urls(small: entity.url))
        return photo
    }
}
