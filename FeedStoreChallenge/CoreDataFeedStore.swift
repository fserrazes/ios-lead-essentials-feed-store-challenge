//
//  Created by Flavio Serrazes on 13.11.20.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import CoreData

public final class CoreDataFeedStore: FeedStore {
    
    private let persistentContainer: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(store url: URL, bundle: Bundle = .main) throws {
        persistentContainer = try NSPersistentContainer.load(model: "CoreDataFeedStore", store: url, in: bundle)
        context = persistentContainer.newBackgroundContext()
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            do {
                let cache = ManagedCache(context: context)
                cache.timestamp = timestamp
                cache.feed = ManagedFeedImage.images(from: feed, in: context)
                
                try self.context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            do {
                if let cache = try ManagedCache.find(in: context) {
                    completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
                } else {
                    completion(.empty)
                }
            }
            catch {
                completion(.failure(error))
            }
        }
    }
}

private extension NSPersistentContainer {
    
    enum LoadError: Swift.Error {
        case modelNotFound
        case loadPersistentStoresFailed(Error)
    }
    
    static func load(model name: String, store url: URL, in bundle: Bundle) throws -> NSPersistentContainer {
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw LoadError.modelNotFound
        }
        
        var loadError: Swift.Error?
        
        let persistentDescription = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [persistentDescription]

        container.loadPersistentStores { (_, error) in
            loadError = error
        }
        try loadError.map { throw LoadError.loadPersistentStoresFailed($0) }
        
        return container
    }
}

private extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle.url(forResource: name, withExtension: "momd").flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}
