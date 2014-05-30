//
//  DataExporter.h
//  Theseus
//
//  Created by Michael Walker on 5/24/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataExporter : NSObject

- (void)uploadToDropbox;
- (void)exportFullDatabase;
@end
