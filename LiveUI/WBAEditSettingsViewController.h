//
//  WBAEditSettingsViewController.h
//  LiveUI
//
//  Created by Ondrej Rafaj on 23/02/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@class WBASettings;

@interface WBAEditSettingsViewController : UITableViewController

@property (nonatomic, copy) void (^dismissController)();

@property (nonatomic, strong) WBASettings *detailItem;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end
