//
//  Path.h
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/25/14.
//  Copyright (c) 2014 Mike Lazer-Walker
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>

typedef NS_ENUM(NSUInteger, MovementType) {
    MovementTypeUnknown,
    MovementTypeWalking,
    MovementTypeRunning,
    MovementTypeBiking,
    MovementTypeTransit
};

#import "TimedEvent.h"

@class Stop;
@class RawMotionActivity;

@interface Path : TimedEvent

@property (nonatomic, strong) NSSet *locations;
@property (nonatomic, strong) RawMotionActivity *activity;
@property (nonatomic, strong) Stop *stop;

@property (nonatomic, readonly) MovementType type;
@property (nonatomic, readonly) NSString *typeString;

- (void)addLocations:(NSArray *)locations;

@end
