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
