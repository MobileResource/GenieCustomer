//
//  ScreenHelper.m
//  GameStaker
//
//  Created by Goldman on 2/5/15.
//  Copyright (c) 2015 TS Application Ltd. All rights reserved.
//

#import "ScreenHelper.h"

@implementation ScreenHelper

+(CGFloat)getScreenWidth{
    return [[UIScreen mainScreen]bounds].size.width;
}

+(CGFloat)getScreenHeight{
    return [[UIScreen mainScreen]bounds].size.height;
}
@end
