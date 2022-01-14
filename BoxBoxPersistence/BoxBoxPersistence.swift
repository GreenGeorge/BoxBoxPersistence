//
//  BoxBoxPersistence.swift
//  BoxBoxPersistence
//
//  Created by George Ananda on 14/01/22.
//

import CoreData

public class BoxBoxPersistence {
    public static let shared = BoxBoxPersistence()
    
    let container: NSPersistentContainer
    
    
    private init() {
        let momdName = "BoxboxModel"
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: momdName, withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        container = NSPersistentContainer(name: momdName, managedObjectModel: mom)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
    }
    

    func save(completion: @escaping(Error?) -> () = {_ in}) {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func delete(_ object: NSManagedObject, completion: @escaping (Error?) -> () = {_ in}) {
        let context = container.viewContext
        context.delete(object)
        save(completion: completion)
    }
    
    func getDrivers(for season: String, completion: @escaping (Result<[DriverMO], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<DriverMO>
        fetchRequest = DriverMO.fetchRequest()

        let seasonPredicate = NSPredicate(format: "ANY %K == %@", "season.title", "2021")
        fetchRequest.predicate = seasonPredicate
        
        let context = container.viewContext
        
        do {
            let results = try context.fetch(fetchRequest)
            completion(.success(results))
        } catch {
            completion(.failure(error))
        }
    }
    
}
