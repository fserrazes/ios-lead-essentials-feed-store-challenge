//
//  Created by Flavio Serrazes on 13.11.20.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import CoreData

@objc(ManagedCache)
public class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
}

extension ManagedCache {
     public static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
         let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
         request.returnsObjectsAsFaults = false
         return try context.fetch(request).first
     }

     internal var localFeed: [LocalFeedImage] {
         return feed.compactMap { ($0 as? ManagedFeedImage)?.local }
     }
 }
