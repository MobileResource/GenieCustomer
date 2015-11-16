//
//  AppDelegate.h
//  GenieCustomer
//
//  Created by Goldman on 3/27/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessagesViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) JSQMessagesViewController * jsqController;

@property (nonatomic) BOOL updateRequets;

@end

