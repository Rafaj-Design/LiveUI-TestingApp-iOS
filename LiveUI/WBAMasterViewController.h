//
//  MasterViewController.h
//  LiveUI
//
//  Created by Ondrej Rafaj on 23/02/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

@import UIKit;
@import CoreData;


@class WBADetailViewController;

@interface WBAMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) WBADetailViewController *detailViewController;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end

