//
//  Created by Flavio Serrazes on 13.11.20.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import CoreData

@objc(ManagedFeedImage)
public class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
}

extension ManagedFeedImage {
     public static func images(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
         return NSOrderedSet(array: localFeed.map { local in
             let managed = ManagedFeedImage(context: context)
             managed.id = local.id
             managed.imageDescription = local.description
             managed.location = local.location
             managed.url = local.url
             return managed
         })
     }

     internal var local: LocalFeedImage {
         return LocalFeedImage(id: id, description: imageDescription, location: location, url: url)
     }
 }
