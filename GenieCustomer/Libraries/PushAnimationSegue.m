//
//  PushAnimationSegue.m
//  GenieProvider
//
//  Created by Goldman on 3/23/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import "PushAnimationSegue.h"

@implementation PushAnimationSegue

- (void)perform {
    [[self.sourceViewController navigationController] pushViewController:[self destinationViewController] animated:YES];
}

@end
