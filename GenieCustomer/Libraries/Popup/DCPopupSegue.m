//
//  DCPopupSegue.m
//  DateCafe
//
//  Created by starlet on 3/9/15.
//  Copyright (c) 2015 lc24master. All rights reserved.
//

#import "DCPopupSegue.h"
#import "UIViewController+Popup.h"
#import <objc/runtime.h>

#define kPopedViewControllerKey "kPopingViewControllerKey"
#define kPopingViewControllerKey "kPopingViewControllerKey"

@interface UIViewController (PopupSegue)

@property (retain, nonatomic) UIViewController* popedViewController;
@property (retain, nonatomic) UIViewController* popingViewController;

@end

@implementation UIViewController (PopupSegue)

- (UIViewController*)popedViewController {
    return objc_getAssociatedObject(self, kPopedViewControllerKey);
}
- (void)setPopedViewController:(UIViewController *)popedViewController {
    objc_setAssociatedObject(self, kPopedViewControllerKey, popedViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController*)popingViewController {
    return objc_getAssociatedObject(self, kPopingViewControllerKey);
}
- (void)setPopingViewController:(UIViewController *)popingViewController {
    objc_setAssociatedObject(self, kPopingViewControllerKey, popingViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation DCPopupSegue

- (void)perform {
    UIViewController *controller = self.sourceViewController;
    UIViewController *popupController = self.destinationViewController;
    
    controller.popedViewController = popupController;
    popupController.popingViewController = controller;
    
    [controller showPopupView:popupController.view animation:YES background:YES backgroundTap:self.backgroudTap contentTouch:self.contentTap dismissed:^(NSInteger completed) {
        if ([controller respondsToSelector:@selector(dismissedPopupWithValue:)]) {
            [(id<DCPopupDismissDelegate>)controller dismissedPopupWithValue:completed];
        }
    }];
}

- (void)performWithDismiss:(NSInteger)dismissValue {
    UIViewController *controller = self.sourceViewController;
    UIViewController *popupController = self.destinationViewController;

    popupController = controller.popingViewController;
    [popupController hidePopupViewWithAnimation:YES dismiss:dismissValue];
}

@end
