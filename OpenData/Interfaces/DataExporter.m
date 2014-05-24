//
//  DataExporter.m
//  OpenData
//
//  Created by Michael Walker on 5/24/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "DataExporter.h"

#import <DropboxSDK/DropboxSDK.h>

@interface DataExporter ()<DBRestClientDelegate>
@property (nonatomic, strong) DBRestClient *dropboxClient;
@end

@implementation DataExporter

- (id)init {
    self = [super init];
    if (!self) return nil;

    return self;
}

- (void)uploadToDropbox {
    self.dropboxClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.dropboxClient.delegate = self;

    [self.dropboxClient loadMetadata:@"/"];

    // Write a file to the local documents directory
    NSString *text = @"Hello world.";
    NSString *filename = @"working-draft.txt";
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [text writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];

    // Upload file to Dropbox
    NSString *destDir = @"/";

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dropboxClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];
    });
}

#pragma mark - DBRestClientDelegate
- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
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
