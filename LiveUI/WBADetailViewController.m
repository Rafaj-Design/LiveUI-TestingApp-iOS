//
//  DetailViewController.m
//  LiveUI
//
//  Created by Ondrej Rafaj on 23/02/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "WBADetailViewController.h"
#import "WBASettings.h"


@interface WBADetailViewController ()

@end


@implementation WBADetailViewController


#pragma mark Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        [self configureView];
    }
}

- (void)configureView {
    if (self.detailItem) {
        [self setTitle:[self.detailItem valueForKey:@"name"]];
        self.detailDescriptionLabel.text = [self.detailItem valueForKey:@"host"];
        
        if (!self.navigationItem.rightBarButtonItem) {
            UIBarButtonItem *reload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshClicked:)];
            [self.navigationItem setRightBarButtonItem:reload];
        }
    }
}

#pragma mark Actions

- (void)refreshClicked:(UIBarButtonItem *)sender {
    
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}


@end
