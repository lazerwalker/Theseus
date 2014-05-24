//
//  SettingsViewController.m
//  OpenData
//
//  Created by Michael Walker on 5/24/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "SettingsViewController.h"
#import "DataExporter.h"

#import <DropboxSDK/DropboxSDK.h>

typedef NS_ENUM(NSInteger, SettingsRows) {
    SettingsRowDropboxExport
};

@interface SettingsViewController ()
@property (nonatomic, strong) DataExporter *exporter;
@end

@implementation SettingsViewController

- (id)init {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass(self.class)
                                                         bundle:nil];
    return [storyboard instantiateInitialViewController];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    if (cell.tag == SettingsRowDropboxExport) {
        if (![[DBSession sharedSession] isLinked]) {
            [[DBSession sharedSession] linkFromController:self];
        }

        self.exporter = [DataExporter new];
        [self.exporter uploadToDropbox];
    }
}

@end
