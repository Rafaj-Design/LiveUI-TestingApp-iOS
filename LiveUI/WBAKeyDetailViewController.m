//
//  WBAKeyDetailViewController.m
//  LiveUI
//
//  Created by Ondrej Rafaj on 24/02/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "WBAKeyDetailViewController.h"
#import "WBATranslations.h"
#import "WBALanguage.h"


@interface WBAKeyDetailViewController ()

@property (nonatomic, readonly) NSArray *languages;

@end


@implementation WBAKeyDetailViewController


#pragma mark Settings

- (void)setKey:(NSString *)key {
    _key = key;
    
    [self setTitle:_key];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    _languages = [[WBATranslations availableLanguages] sortedArrayUsingDescriptors:@[sort]];
}

#pragma mark Table view delegate & data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _languages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    WBALanguage *lang = _languages[indexPath.row];
    NSString *name = (lang.isDefault ? [NSString stringWithFormat:@"%@ (default)", lang.name] : lang.name);
    [cell.textLabel setText:name];
    [cell.detailTextLabel setText:[WBATranslations get:_key forLanguage:lang.code]];
    
    return cell;
}


@end
