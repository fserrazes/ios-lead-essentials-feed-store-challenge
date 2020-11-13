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
