//
//  SettingsViewController.m
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

#import "SettingsViewController.h"
#import "DataExporter.h"

#import <VTAcknowledgementsViewController.h>
#import <DropboxSDK/DropboxSDK.h>

typedef NS_ENUM(NSInteger, SettingsRows) {
    SettingsRowDropboxExport,
    SettingsRowFullDBExport,
    SettingsRowAcknowledgements
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    switch (cell.tag) {
        case SettingsRowDropboxExport: {
            if (![[DBSession sharedSession] isLinked]) {
                [[DBSession sharedSession] linkFromController:self];
            } else {
                self.exporter = [DataExporter new];
                [self.exporter uploadToDropbox];
            }
            break;
        }
        case SettingsRowFullDBExport: {
            if (![[DBSession sharedSession] isLinked]) {
                [[DBSession sharedSession] linkFromController:self];
            } else {
                self.exporter = [DataExporter new];
                [self.exporter exportFullDatabase];
            }
            break;
        }
        case SettingsRowAcknowledgements: {
            VTAcknowledgementsViewController *acknowledgementsController = [VTAcknowledgementsViewController acknowledgementsViewController];
            [self.navigationController pushViewController:acknowledgementsController animated:YES];
        }
    }
}

@end
