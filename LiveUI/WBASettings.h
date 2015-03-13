//
//  WBASettings.h
//  LiveUI
//
//  Created by Ondrej Rafaj on 24/02/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

@import CoreData;


@interface WBASettings : NSManagedObject

@property (nonatomic, retain) NSString *apiKey;
@property (nonatomic, retain) NSNumber *appId;
@property (nonatomic, retain) NSNumber *port;
@property (nonatomic, retain) NSString *host;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *version;


@end
