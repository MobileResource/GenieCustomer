//
//  PushAnimationSegue.m
//  GenieProvider
//
//  Created by Goldman on 3/23/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import "PushNoAnimationSegue.h"

@implementation PushNoAnimationSegue

- (void)perform {
    [[self.sourceViewController navigationController] pushViewController:[self destinationViewController] animated:NO];
}

@end
