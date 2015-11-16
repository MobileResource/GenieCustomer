//
//  UIViewController+Popup.m
//  Cloud
//
//  Created by Starlet on 11/24/13.
//  Copyright (c) 2013 SM. All rights reserved.
//

#import "UIViewController+Popup.h"
#import <objc/runtime.h>
#import "KLCPopup.h"

#define kAlphaBackgroundViewID "kAlphaBackgroundViewID"
#define kBackgroundCotnrolID "kBackgroundCotnrolID"
#define kPopupViewArrayID "kPopupViewArrayID"
#define kHasBackgroundAlphaID "kHasBackgroundAlphaID"
#define kHasBackgroundTapID "kHasBackgroundTapID"
#define kPopupViewDismissedArrayKey "kPopupViewDismissedArrayKey"

@interface UIViewController ()
@property (retain, nonatomic) UIView* alphaBackgroundView;
@property (retain, nonatomic) UIControl* backgroundControl;
@property (retain, nonatomic) NSMutableArray* popupViewArray;
@property (retain, nonatomic) NSMutableArray* popupDismissCallbackArray;

@property (assign, nonatomic) KLCPopup* kLCPopupView;

@end

@implementation UIViewController (Popup)

- (void)setAlphaBackgroundView:(UIView *)alphaBackgroundView {
    objc_setAssociatedObject(self, kAlphaBackgroundViewID, alphaBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView*)alphaBackgroundView {
    return objc_getAssociatedObject(self, kAlphaBackgroundViewID);
}

- (void)setBackgroundControl:(UIControl *)backgroundControl {
    objc_setAssociatedObject(self, kBackgroundCotnrolID, backgroundControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIControl*)backgroundControl {
    return objc_getAssociatedObject(self, kBackgroundCotnrolID);
}

- (NSMutableArray*)popupViewArray {
    return objc_getAssociatedObject(self, kPopupViewArrayID);
}
- (void)setCurrentPopupView:(UIView *)currentPopupView {
    NSMutableArray* popupViews = self.popupViewArray;
    if (popupViews == nil) {
        popupViews = [NSMutableArray new];
        objc_setAssociatedObject(self, kPopupViewArrayID, popupViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (currentPopupView)
        [popupViews addObject:currentPopupView];
    else
        [popupViews removeLastObject];
}
- (UIView*)currentPopupView {
    return [self.popupViewArray lastObject];
}

- (void)setHasBackgoundAlpha:(NSNumber*)hasBackgoundAlpha {
    objc_setAssociatedObject(self, kHasBackgroundAlphaID, hasBackgoundAlpha, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber*)hasBackgoundAlpha {
    return objc_getAssociatedObject(self, kHasBackgroundAlphaID);
}

- (void)setHasBackgoundTap:(NSNumber*)hasBackgoundTap {
    objc_setAssociatedObject(self, kHasBackgroundTapID, hasBackgoundTap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber*)hasBackgoundTap {
    return objc_getAssociatedObject(self, kHasBackgroundTapID);
}

- (void)setKLCPopupView:(KLCPopup *)popupView {
    [self setCurrentPopupView:popupView];
}
- (KLCPopup*)kLCPopupView {
    return (KLCPopup*)[self currentPopupView];
}

#pragma mark --- Dismissed

- (NSMutableArray*)popupDismissCallbackArray {
    return objc_getAssociatedObject(self, kPopupViewDismissedArrayKey);
}

- (void)setDismissedCallback:(fDismissCallback) dismissed
{
    NSMutableArray* popupCallbacks = self.popupDismissCallbackArray;
    if (popupCallbacks == nil) {
        popupCallbacks = [NSMutableArray new];
        objc_setAssociatedObject(self, kPopupViewDismissedArrayKey, popupCallbacks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (dismissed)
        [popupCallbacks addObject:dismissed];
    else
        [popupCallbacks addObject:[NSNull null]];
}
- (void)removeDismissedCallback
{
    [self.popupDismissCallbackArray removeLastObject];
}
- (fDismissCallback)dismissedCallback
{
    id callback = [self.popupDismissCallbackArray lastObject];
    if (callback == NSNull.null)
        return nil;
    return callback;
}

- (BOOL)isPopupHidden {
    return self.popupViewArray.count < 1;
}
- (void)hideAllPopupViews {
    [self.popupDismissCallbackArray removeAllObjects];
    
    for (KLCPopup* popupView in self.popupViewArray) {
        popupView.didFinishDismissingCompletion = nil;
        [popupView dismiss:NO];
    }
    [self.popupViewArray removeAllObjects];
}

- (void)showPopupView:(UIView*) view animation:(BOOL)animation dismissed:(fDismissCallback)handler {
    [self setDismissedCallback:handler];
    
    [self showPopupView:view animation:animation];
}

- (void)showPopupView:(UIView*) view animation:(BOOL)animation {
    BOOL hasBackground = self.hasBackgoundAlpha.boolValue;
    KLCPopup* popup = [KLCPopup popupWithContentView:view showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:(hasBackground ? KLCPopupMaskTypeDimmed : KLCPopupMaskTypeClear) dismissOnBackgroundTouch:self.hasBackgoundTap.boolValue dismissOnContentTouch:NO];
    if (self.hasBackgoundTap.boolValue) {
        popup.didFinishDismissingCompletion = ^ {
            fDismissCallback callback = [self dismissedCallback];
            [self removeDismissedCallback];
            if (callback)
                callback(0);//NO
        };
    }
    
    //20141125.LC add. if viewcontroller is dismiss all popup, then hide this popup
    __block KLCPopup* dpPopup = popup;
    popup.didFinishShowingCompletion = ^ {
        if (self.popupViewArray.count < 1) {
            dpPopup.didFinishDismissingCompletion = nil;
            [dpPopup dismiss:NO];
        }
    };

//    if (self.view && ![self.view isKindOfClass:[UITableView class]]) {
//        [self.view addSubview:popup];
//        popup.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[popup]|"
//                                                                         options:0
//                                                                         metrics:nil
//                                                                           views:NSDictionaryOfVariableBindings(popup)]];
//        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[popup]|"
//                                                                         options:0
//                                                                         metrics:nil
//                                                                           views:NSDictionaryOfVariableBindings(popup)]];
//    }
    [popup show];
    self.kLCPopupView = popup;
}
- (void)showPopupView:(UIView*) view animation:(BOOL)animation background:(BOOL)hasBackground backgroundTap:(BOOL)backgroundTap contentTouch:(BOOL)contentTouch dismissed:(fDismissCallback)handler
{
    [self setDismissedCallback:handler];

    KLCPopup* popup = [KLCPopup popupWithContentView:view showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:(hasBackground ? KLCPopupMaskTypeDimmed : KLCPopupMaskTypeClear) dismissOnBackgroundTouch:backgroundTap dismissOnContentTouch:contentTouch];
    if (self.hasBackgoundTap.boolValue) {
        popup.didFinishDismissingCompletion = ^ {
            fDismissCallback callback = [self dismissedCallback];
            [self removeDismissedCallback];
            if (callback)
                callback(0);//NO
        };
    }
    
    //20141125.LC add. if viewcontroller is dismiss all popup, then hide this popup
    __block KLCPopup* dpPopup = popup;
    popup.didFinishShowingCompletion = ^ {
        if (self.popupViewArray.count < 1) {
            dpPopup.didFinishDismissingCompletion = nil;
            [dpPopup dismiss:NO];
        }
    };
    
//    if (self.view && ![self.view isKindOfClass:[UITableView class]]) {
//        [self.view addSubview:popup];
//        popup.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[popup]|"
//                                                                         options:0
//                                                                         metrics:nil
//                                                                           views:NSDictionaryOfVariableBindings(popup)]];
//        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[popup]|"
//                                                                         options:0
//                                                                         metrics:nil
//                                                                           views:NSDictionaryOfVariableBindings(popup)]];
//    }
    [popup show];
    self.kLCPopupView = popup;
}

- (void) hidePopupViewWithAnimation:(BOOL)animation dismiss:(NSInteger)returnDismiss {
    KLCPopup* popupView = self.kLCPopupView;
    self.kLCPopupView = nil;
    popupView.didFinishDismissingCompletion = nil;
    [popupView dismiss:animation];
    
    fDismissCallback callback = [self dismissedCallback];
    [self removeDismissedCallback];
    if (callback)
        callback(returnDismiss);
}
#if 0
- (void)showPopupView:(UIView*) view animation:(BOOL)animation {
    UIView *alphaView = self.alphaBackgroundView;
    UIViewController* rootViewController = self;//self.tabBarController;
//    if (rootViewController == nil)
//        rootViewController = self.navigationController;
//    if (rootViewController == nil)
//        rootViewController = self;

    if (alphaView == nil && self.hasBackgoundAlpha.boolValue) {
        CGRect frame = rootViewController.view.bounds;
        alphaView = [[UIView alloc] initWithFrame:frame];
        alphaView.userInteractionEnabled = YES;
        alphaView.opaque = NO;
        alphaView.backgroundColor = [UIColor blackColor];
        alphaView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        self.alphaBackgroundView = alphaView;
    }
    
    if (alphaView) {
        alphaView.alpha = 0;
        [rootViewController.view addSubview:alphaView];
        [rootViewController.view bringSubviewToFront:alphaView];
    }
    
    //- Popup window, touch another portion
    UIControl* bgControl = self.backgroundControl;
    if (bgControl == nil && self.hasBackgoundTap.boolValue) {
        bgControl = [[UIControl alloc] initWithFrame:CGRectZero];
        [bgControl addTarget:self action:@selector(backgroundTap:) forControlEvents:UIControlEventTouchUpInside];
        bgControl.backgroundColor = [UIColor clearColor];
        self.backgroundControl = bgControl;
    }
    
    if (bgControl) {
        [rootViewController.view addSubview:bgControl];//alphaView
        [rootViewController.view bringSubviewToFront:bgControl];
    }
    
    self.currentPopupView = view;
    CGRect popupframe = view.frame;
    CGRect frame = rootViewController.view.bounds;
    NSInteger x = frame.origin.x + round((frame.size.width - popupframe.size.width) / 2);
    NSInteger y = frame.origin.y + round((frame.size.height - popupframe.size.height) / 2);
    
    CGRect frame1 = popupframe;
    frame1.origin.x = x;
    frame1.origin.y = frame.size.height;
    CGRect frame2 = frame1;
    frame2.origin.y = y;
    
    bgControl.frame = frame;//CGRectMake(0, 0, frame1.size.width, self.view.frame.size.height - h);
    view.frame = frame1;
    
    [rootViewController.view addSubview:view];
    
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            alphaView.alpha = 0.5;
            view.frame = frame2;
        } completion:^(BOOL finished) {
        }];
    } else {
        alphaView.alpha = 0.5;
        view.frame = frame2;
    }
}

- (void) hidePopupViewWithAnimation:(BOOL)animation dismiss:(BOOL)returnDismiss {
    UIView* popupView = self.currentPopupView;
    UIView* alphaBgView = self.alphaBackgroundView;
    UIControl* bgControl = self.backgroundControl;
    
    UIViewController* rootViewController = self;//self.tabBarController;
//    if (rootViewController == nil)
//        rootViewController = self.navigationController;
//    if (rootViewController == nil)
//        rootViewController = self;

    CGRect frame = popupView.frame;
    frame.origin.y = rootViewController.view.bounds.size.height;
    if(popupView) {
        self.currentPopupView = nil;

        if (animation) {
            [UIView animateWithDuration:0.3 animations:^{
                popupView.frame = frame;
                alphaBgView.alpha = 0;
            } completion:^(BOOL finished) {
                [popupView removeFromSuperview];
                [alphaBgView removeFromSuperview];
                [bgControl removeFromSuperview];

                fDismissCallback callback = [self dismissedCallback];
                [self removeDismissedCallback];
                if (returnDismiss && callback)
                    callback();
            }];
        } else {
            popupView.frame = frame;
            alphaBgView.alpha = 0;
            [popupView removeFromSuperview];

            [alphaBgView removeFromSuperview];
            [bgControl removeFromSuperview];

            fDismissCallback callback = [self dismissedCallback];
            [self removeDismissedCallback];
            if (returnDismiss && callback)
                callback();
        }
    }
}
#endif
- (void)backgroundTap:(id)sender
{
    if(self.hasBackgoundTap.boolValue == YES)
    {
        [self hidePopupViewWithAnimation:YES dismiss:NO];
        self.hasBackgoundTap = [NSNumber numberWithBool:NO];
    }
}

+ (UIFont*)defaultAlertFont {
    return [UIFont systemFontOfSize:14];
}
+ (UIColor*)defaultAlertTextColor {
    return [UIColor darkGrayColor];
}
+ (NSDictionary*)defaultAlertTextAttributes {
    return [NSDictionary dictionaryWithObjectsAndKeys:[UIViewController defaultAlertFont],NSFontAttributeName, [UIViewController defaultAlertTextColor], NSForegroundColorAttributeName, nil];
}


- (void)showPopupMessageView:(NSString*)title message:(id)message button:(NSString*)buttonTitle dismissed:(fDismissCallback)handler {
    SMPopupAlertView* alertView = [SMPopupAlertView sharedMessageView:self];
    [alertView setTitle:title message:message button:buttonTitle];
    [self showPopupView:alertView animation:YES dismissed:handler];
}

- (void)showPopupAlertView:(NSString*)title message:(id)message button:(NSString*)buttonTitle dismissed:(fDismissCallback)handler {
    SMPopupAlertView* alertView = [SMPopupAlertView sharedAlertView:self];
    [alertView setTitle:title message:message button:buttonTitle];
    [self showPopupView:alertView animation:YES dismissed:handler];
}

@end


@implementation SMPopupAlertView

static SMPopupAlertView* sAlertView = nil;
+ (SMPopupAlertView*)sharedMessageView:(UIViewController*)viewController {
    if (sAlertView == nil) {
        NSArray* viewArray = [[NSBundle mainBundle] loadNibNamed:@"SMPopupAlertView" owner:nil options:nil];
        sAlertView = [viewArray lastObject];
        if (sAlertView == nil) {
            sAlertView = [[SMPopupAlertView alloc] initWithFrame:CGRectMake(0, 0, 280, 148)];
        }
    }
    sAlertView.okButton.hidden = NO;
    sAlertView.okButton1.hidden = YES;
    sAlertView.cancelButton.hidden = NO;
    sAlertView.cancelButton1.hidden = YES;
    sAlertView.viewController = viewController;
    return sAlertView;
}

+ (SMPopupAlertView*)sharedAlertView:(UIViewController*)viewController {
    if (sAlertView == nil) {
        NSArray* viewArray = [[NSBundle mainBundle] loadNibNamed:@"SMPopupAlertView" owner:nil options:nil];
        sAlertView = [viewArray lastObject];
        if (sAlertView == nil) {
            sAlertView = [[SMPopupAlertView alloc] initWithFrame:CGRectMake(0, 0, 280, 148)];
        }
    }
    sAlertView.okButton1.hidden = NO;
    sAlertView.cancelButton.hidden = NO;
    sAlertView.cancelButton1.hidden = NO;
    sAlertView.okButton.hidden = YES;
    sAlertView.viewController = viewController;
    return sAlertView;
}

- (void)setTitle:(NSString*)title message:(id)message button:(NSString*)buttonTitle {
    if (title)
        self.titleLabel.text = title;
    if (message == nil)
        message = @"";
    
    if ([message isKindOfClass:NSString.class])
        self.messageLabel.text = message;
    else if ([message isKindOfClass:NSAttributedString.class])
        self.messageLabel.attributedText = message;
    else
        self.messageLabel.text = @"";
    
    if (buttonTitle.length < 1)
        buttonTitle = @"OK";

    if (!self.okButton.isHidden)
        [self.okButton setTitle:buttonTitle forState:UIControlStateNormal];
    if (!self.okButton1.isHidden)
        [self.okButton1 setTitle:buttonTitle forState:UIControlStateNormal];
}

- (IBAction)selectClose:(id)sender {
    [self.viewController hidePopupViewWithAnimation:YES dismiss:NO];
}

- (IBAction)selectOK:(id)sender {
    [self.viewController hidePopupViewWithAnimation:YES dismiss:YES];
}

@end
