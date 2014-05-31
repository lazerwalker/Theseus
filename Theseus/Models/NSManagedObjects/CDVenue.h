//
//  CDVenue.h
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/19/14.
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

@interface CDVenue : NSManagedObject

@property (nonatomic, retain) NSString* foursquareId;
@property (nonatomic, retain) NSNumber* latitude;
@property (nonatomic, retain) NSNumber* longitude;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSSet *stops;

@property (nonatomic, retain) NSString* foursquareIconSuffix;
@property (nonatomic, retain) NSString* foursquareIconPrefix;


@end
