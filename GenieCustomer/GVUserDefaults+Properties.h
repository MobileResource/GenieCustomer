//
//  GVUserDefaults+Properties.h
//  GameStaker
//
//  Created by Goldman on 2/5/15.
//  Copyright (c) 2015 TS Application Ltd. All rights reserved.
//

#ifndef GameStaker_GVUserDefaults_Properties_h
#define GameStaker_GVUserDefaults_Properties_h
#import "GVUserDefaults.h"

@interface GVUserDefaults (Properties)

@property (nonatomic, weak) NSString* csName;
@property (nonatomic, weak) NSString * csId;
@property (nonatomic, weak) NSString * csEmail;
@property (nonatomic, weak) NSString * csImage;
@property (nonatomic, weak) NSString* device_token;
@property (nonatomic, weak) NSString* csNotification;
@end

#endif
