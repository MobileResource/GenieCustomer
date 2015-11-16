//
//  GVUserDefaults+Properties.m
//  GameStaker
//
//  Created by Goldman on 2/5/15.
//  Copyright (c) 2015 TS Application Ltd. All rights reserved.
//

#import "GVUserDefaults+Properties.h"

@implementation GVUserDefaults (Properties)

@dynamic csName;
@dynamic csId;
@dynamic csEmail;
@dynamic csImage;
@dynamic device_token;
@dynamic csNotification;

- (NSDictionary*) setupDefaults{
    return @{
             @"csName":@"",
             @"csId": @"",
             @"csEmail": @"",
             @"csImage": @"",
             @"device_token": @"",
             @"csNotification":@""
    };
}

@end
