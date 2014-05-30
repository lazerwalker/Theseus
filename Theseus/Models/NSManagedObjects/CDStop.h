//
//  _Stop.h
//  Theseus
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "CDTimedEvent.h"

@class CDPath;
@class CDVenue;

@interface CDStop : NSManagedObject<CDTimedEvent>

@property (nonatomic) NSSet *locations;
@property (nonatomic) NSSet *movementPaths;
@property (nonatomic) NSNumber *venueConfirmed;
@property (nonatomic) CDVenue *venue;

@end
