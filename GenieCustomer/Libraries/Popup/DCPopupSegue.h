//
//  DCPopupSegue.h
//  DateCafe
//
//  Created by starlet on 3/9/15.
//  Copyright (c) 2015 lc24master. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DCPopupDismissDelegate <NSObject>

- (void)dismissedPopupWithValue:(NSInteger)nDismiss;

@end

@interface DCPopupSegue : UIStoryboardSegue

@property (assign, nonatomic) BOOL backgroudTap;
@property (assign, nonatomic) BOOL contentTap;

- (void)performWithDismiss:(NSInteger)dismissValue;

@end
