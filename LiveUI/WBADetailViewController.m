//
//  DetailViewController.m
//  LiveUI
//
//  Created by Ondrej Rafaj on 23/02/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "WBADetailViewController.h"
#import "WBAKeyDetailViewController.h"
#import "WBAMain.h"
#import "WBATranslations.h"
#import "WBATranslationData.h"
#import "WBASettings.h"


@interface WBADetailViewController ()

@property (nonatomic, readonly) NSArray *keys;

@end


@implementation WBADetailViewController


#pragma mark Managing the detail item

- (void)reloadData {
    WBATranslationData *basicData = [[WBATranslationData alloc] initWithBundledWBALocalizationFileNamed:@"" withDefaultLanguageCode:@"en"];
    //[[WBAMain sharedWBA] startTranslationsWithBasicData:basicData andApplicationId:2];
    NSString *urlString = [NSString stringWithFormat:@"http://s3.amazonaws.com/admin.wellbakedapp.com/API_1.0/%ld/%@/", (long)_detailItem.appId.integerValue, _detailItem.version];
    [[WBAMain sharedWBA] startTranslationsWithBasicData:basicData andCustomUrl:[NSURL URLWithString:urlString]];
    //[[WBAMain sharedWBA] startTranslationsWithBasicData:basicData];
    
    //[[WBAMain sharedWBA] setDebugMode:YES];
}

- (void)reloadStaticValues {
    NSArray *keys = [WBATranslations allKeys];
    _keys = [keys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (void)setDetailItem:(WBASettings *)detailItem {
    if (_detailItem != detailItem) {
        _detailItem = detailItem;
            
        [self configureView];
        
        __weak typeof(self) weakSelf = self;
        [[WBAMain sharedWBA].translations setDidReceiveInfoFileResponse:^(NSDictionary *data, NSError *error) {
            NSLog(@"Info: %@ - %@", data, error.localizedDescription);
        }];
        [[WBAMain sharedWBA].translations setDidReceiveLocalizationFileResponse:^(NSDictionary *data, NSError *error) {
            [weakSelf reloadStaticValues];
            
            [weakSelf.tableView reloadData];
        }];
        [[WBAMain sharedWBA].translations setLocalizationFilesAreUpToDate:^{
            [weakSelf reloadStaticValues];
            
            [weakSelf.tableView reloadData];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update" message:@"Localization files are up-to-date with the version on the server." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }];
        [self reloadData];
    }
}

- (void)configureView {
    if (self.detailItem) {
        [self setTitle:[self.detailItem valueForKey:@"name"]];
        
        if (!self.navigationItem.rightBarButtonItem) {
            UIBarButtonItem *reload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshClicked:)];
            [self.navigationItem setRightBarButtonItem:reload];
        }
    }
}

#pragma mark Actions

- (void)refreshClicked:(UIBarButtonItem *)sender {
    [self reloadData];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}

#pragma mark Table view delegate & data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _keys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    NSString *key = _keys[indexPath.row];
    [cell.textLabel setText:key];
    [cell.detailTextLabel setText:WBAGet(key)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *key = _keys[indexPath.row];
    
    WBAKeyDetailViewController *c = [[WBAKeyDetailViewController alloc] init];
    [c setKey:key];
    [self.navigationController pushViewController:c animated:YES];
}


@end
