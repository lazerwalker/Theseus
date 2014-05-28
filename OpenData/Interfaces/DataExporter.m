//
//  DataExporter.m
//  OpenData
//
//  Created by Michael Walker on 5/24/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "DataExporter.h"
#import "Day.h"
#import <DropboxSDK/DropboxSDK.h>
#import "DataProcessor.h"

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
    @autoreleasepool {
        for (int i=0; i<4; i++) {
            Day *day = [[Day alloc] initWithDaysAgo:i];
            NSString *text = day.jsonRepresentation;

            NSString *filename = [NSString stringWithFormat:@"%lu.txt", (long)day.daysAgo];
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

    DataProcessor *processor = DataProcessor.sharedInstance;
    NSArray *data = processor.allRawData;
    data = [MTLJSONAdapter JSONArrayFromModels:data];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                   options:NSJSONWritingPrettyPrinted
                                                    error:nil];
    if (!jsonData) return;

    NSString *text = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSString *filename = [NSString stringWithFormat:@"%@.json", [dateFormatter stringFromDate:NSDate.date]];
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [text writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];

    [self.dropboxClient uploadFile:filename toPath:@"/" withParentRev:nil fromPath:localPath];
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
