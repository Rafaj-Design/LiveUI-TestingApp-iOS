//
//  WBAMain.h
//
//  Created by Ondrej Rafaj on 01/02/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBAMacros.h"
#import "WBAEnums.h"


extern NSString *const WBATranslationDataHasBeenUpdatedNotification;
extern NSString *const WBATranslationDataTranslationBeenUpdatedNotification;


@class WBATranslationData, WBATranslations;

@interface WBAMain : NSObject


@property (nonatomic, readonly) WBATranslationData *data;

// Based on what start method has been used, could be default for wellbakedapp.com, custom for any custom URL you might uploaded the API files to or local only which only takes files from the bundle. Each variant requires bundle files to be present.
@property (nonatomic, readonly) WBATranslationDataSourceOrigin dataSourceOrigin;

// Custom url that contains publicly available translation files
@property (nonatomic, readonly) NSURL *customUrl;

// Load iOS only keys or all keys
@property (nonatomic) WBADataType dataType; // Default is iOS only (which includes all platforms keys too!)

// ------------ Source is wellbakedapp.com (WBATranslationDataSourceOriginDefault) ------------
// ID of the application
@property (nonatomic) NSInteger applicationId;
// Use staging, live or define custom using for example "buildTranslationVersion"
@property (nonatomic) WBABuild buildType; // Default is live

// ------------ Source is custom URL ------------
// If "buildType" is set to custom, you can specify the exact version of translation to be used
@property (nonatomic) NSInteger buildTranslationVersion;

// Enable debug mode
@property (nonatomic) WBADebugMode debugMode; // Default is none

// Shared instance
+ (instancetype)sharedWBA;

// Use wellbakedapp.com as a source (WBATranslationDataSourceOriginDefault)
- (void)startTranslationsWithBasicData:(WBATranslationData *)data andApplicationId:(NSInteger)applicationId;
// Use custom URL to host your API files (WBATranslationDataSourceOriginCustom)
- (void)startTranslationsWithBasicData:(WBATranslationData *)data andCustomUrl:(NSURL *)url;
// Use only locally bundled data (WBATranslationDataSourceOriginLocalOnly)
- (void)startBasicData:(WBATranslationData *)data;


@end
