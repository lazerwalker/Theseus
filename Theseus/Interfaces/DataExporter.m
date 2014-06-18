//
//  DataExporter.m
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/24/14.
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

#import "DataExporter.h"
#import "Day.h"
#import <DropboxSDK/DropboxSDK.h>

#import "RawMotionActivity.h"
#import "RawLocation.h"

@interface DataExporter ()<DBRestClientDelegate>
@property (nonatomic, strong) DBRestClient *dropboxClient;
@end

@implementation DataExporter

- (id)init {
    self = [super init];
    if (!self) return nil;

    self.dropboxClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.dropboxClient.delegate = self;

    return self;
}

- (void)uploadToDropbox {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"MM-dd-yyyy";

    @autoreleasepool {
        for (int i=0; i<4; i++) {
            Day *day = [[Day alloc] initWithDaysAgo:i];
            NSString *text = day.jsonRepresentation;
            if (!text) continue;

            NSString *filename = [NSString stringWithFormat:@"%@.json", [dateFormatter stringFromDate:day.date]];
            NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            NSString *localPath = [localDir stringByAppendingPathComponent:filename];
            [text writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];

            // Upload file to Dropbox
            NSString *destDir = @"/";

            [self.dropboxClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];
        }
    }
}

- (void)exportFullDatabase {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"MM-dd-yyyy";

    NSArray *data = [self allRawData];
    data = [MTLJSONAdapter JSONArrayFromModels:data];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                   options:NSJSONWritingPrettyPrinted
                                                    error:nil];
    if (!jsonData) return;

    NSString *text = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSString *filename = [NSString stringWithFormat:@"Raw-%@.json", [dateFormatter stringFromDate:NSDate.date]];
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [text writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];

    [self.dropboxClient uploadFile:filename toPath:@"/" withParentRev:nil fromPath:localPath];
}

- (NSArray *)allRawData {
    NSArray *motionEvents = [RawMotionActivity MR_findAllSortedBy:@"timestamp" ascending:YES];
    NSArray *locationEvents = [RawLocation MR_findAllSortedBy:@"timestamp" ascending:YES];

    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    NSArray *allObjects = [[motionEvents arrayByAddingObjectsFromArray:locationEvents] sortedArrayUsingDescriptors:@[descriptor]];
    return allObjects;
}

#pragma mark - DBRestClientDelegate
- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    [[[UIAlertView alloc] initWithTitle:@"Export Complete" message:@"Your export was successful." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"Export Failed" message:[NSString stringWithFormat:@"Your export failed with the following error: %@", error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"	%@", file.filename);
        }
    }
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error);
}

@end
