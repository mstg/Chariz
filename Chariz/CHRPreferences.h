//
//  CHRPreferences.h
//  Chariz
//
//  Created by Adam D on 15/02/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHRPreferences : NSObject

+ (instancetype)sharedInstance;

@property (strong, nonatomic) NSDate *lastLaunch;
@property (nonatomic) BOOL firstLaunch;

@end
