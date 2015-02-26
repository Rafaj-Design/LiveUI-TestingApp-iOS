//
//  WBAEditSettingsViewController.m
//  LiveUI
//
//  Created by Ondrej Rafaj on 23/02/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "WBAEditSettingsViewController.h"
#import <RETableViewManager/RETableViewManager.h>
#import "AppDelegate.h"
#import "WBASettings.h"


@interface WBAEditSettingsViewController ()

@property (nonatomic, readonly) RETableViewManager *manager;

@property (nonatomic, readonly) RETextItem *accountName;
@property (nonatomic, readonly) RETextItem *serverHost;
@property (nonatomic, readonly) RENumberItem *serverPort;
@property (nonatomic, readonly) RENumberItem *appId;
@property (nonatomic, readonly) RETextItem *versionId;
@property (nonatomic, readonly) RETextItem *apiKey;

@end


@implementation WBAEditSettingsViewController


#pragma mark Creating elements

- (void)createNavBarButtons {
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close:)];
    [self.navigationItem setLeftBarButtonItem:close];
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    [self.navigationItem setRightBarButtonItem:save];
}

- (void)createTableElements {
    //__typeof(self) __weak weakSelf = self;
    
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"Account"];
    [_manager addSection:section];
    
    _accountName = [RETextItem itemWithTitle:@"Name" value:nil placeholder:@"Account name"];
    [_accountName setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_accountName setValidators:@[@"presence", @"length(1, 999)"]];
    [_accountName setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [section addItem:_accountName];
    
    section = [RETableViewSection sectionWithHeaderTitle:@"Server"];
    [_manager addSection:section];
    
    _serverHost = [RETextItem itemWithTitle:@"Host" value:nil placeholder:@"http://my.example-host.com"];
    [_serverHost setClearButtonMode:UITextFieldViewModeWhileEditing];
    //[_serverHost setEnabled:NO];
    [_serverHost setValidators:@[@"presence"]];
    [_serverHost setKeyboardType:UIKeyboardTypeURL];
    [_serverHost setAutocorrectionType:UITextAutocorrectionTypeNo];
    [section addItem:_serverHost];
    
//    _serverPort = [RENumberItem itemWithTitle:@"Port" value:nil placeholder:@"80" format:@"XXXXXXXX"];
//    [_serverPort setClearButtonMode:UITextFieldViewModeWhileEditing];
//    [_serverPort setEnabled:NO];
//    [_serverPort setValidators:@[@"presence", @"length(1, 8)"]];
//    [section addItem:_serverPort];
    
    _appId = [RENumberItem itemWithTitle:@"App ID" value:nil placeholder:@"2"];
    [_appId setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_appId setValidators:@[@"presence"]];
    [section addItem:_appId];
    
    _versionId = [RETextItem itemWithTitle:@"Version ID" value:nil placeholder:@"1, 2, 3, live, staging ..."];
    [_versionId setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_versionId setValidators:@[@"presence"]];
    [_versionId setKeyboardType:UIKeyboardTypeURL];
    [_versionId setAutocorrectionType:UITextAutocorrectionTypeNo];
    [section addItem:_versionId];
    
//    _apiKey = [RETextItem itemWithTitle:@"API Key" value:nil placeholder:@"laufhao78f67sdg58gs4dga4df8gad"];
//    [_apiKey setClearButtonMode:UITextFieldViewModeWhileEditing];
//    [_apiKey setEnabled:NO];
//    [_versionId setValidators:@[@"presence"]];
//    [_versionId setKeyboardType:UIKeyboardTypeURL];
//    [_versionId setAutocorrectionType:UITextAutocorrectionTypeNo];
//    [section addItem:_apiKey];
    
    [self assignValues];
}

- (void)createAllElements {
    [self createNavBarButtons];
    [self createTableElements];
}

#pragma mark Settings

- (void)assignValues {
    if (_detailItem) {
        [_accountName setValue:_detailItem.name];
        [_serverHost setValue:_detailItem.host];
        [_serverPort setValue:[NSString stringWithFormat:@"%ld", (long)_detailItem.port.integerValue]];
        [_appId setValue:[NSString stringWithFormat:@"%ld", (long)_detailItem.appId.integerValue]];
        [_versionId setValue:_detailItem.version];
        [_apiKey setValue:_detailItem.apiKey];
    }
    else {
        [_accountName setValue:@":)"];
        [_serverHost setValue:@"http://s3.amazonaws.com/admin.wellbakedapp.com/API_1.0"];
        //[_serverHost setValue:@""];
        //[_serverPort setValue:@"80"];
        [_serverPort setValue:@""];
        [_appId setValue:@"2"];
        [_versionId setValue:@"staging"];
        [_apiKey setValue:@""];
    }
    
    [self.tableView reloadData];
}

- (void)setDetailItem:(id)detailItem {
    _detailItem = detailItem;
    
    if (_detailItem) {
        [self setTitle:@"Edit"];
    }
    else {
        [self setTitle:@"Add"];
    }
    
    [self assignValues];
}

#pragma mark View lifecyle

- (void)loadView {
    [super loadView];
    
    [self createAllElements];
}

#pragma mark Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setTitle:@"Add"];
    }
    return self;
}

#pragma mark Actions

- (void)save:(UIBarButtonItem *)sender {
    NSArray *managerErrors = _manager.errors;
    if (managerErrors.count > 0) {
        NSMutableArray *errors = [NSMutableArray array];
        for (NSError *error in managerErrors) {
            [errors addObject:error.localizedDescription];
        }
        NSString *errorString = [errors componentsJoinedByString:@"\n"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        WBASettings *settings = _detailItem;
        if (!_detailItem) {
            settings = [NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:_managedObjectContext];
        }
        [settings setName:_accountName.value];
        [settings setHost:_serverHost.value];
        [settings setPort:[NSNumber numberWithInteger:_serverPort.value.integerValue]];
        [settings setAppId:[NSNumber numberWithInteger:_appId.value.integerValue]];
        [settings setVersion:_versionId.value];
        [settings setApiKey:_apiKey.value];
        [delegate saveContext];
        
        if (_dismissController) {
            _dismissController();
        }
    }
}

- (void)close:(UIBarButtonItem *)sender {
    if (_dismissController) {
        _dismissController();
    }
}


@end
