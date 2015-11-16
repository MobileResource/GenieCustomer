//
//  UIViewController+Popup.h
//  Cloud
//
//  Created by Starlet on 11/24/13.
//  Copyright (c) 2013 SM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ fDismissCallback)(NSInteger completed);//maybe buttonindex


@interface SMPopupAlertView : UIView

@property (nonatomic, strong) IBOutlet UIViewController  *viewController;
@property (nonatomic, strong) IBOutlet UILabel    *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel    *messageLabel;
@property (nonatomic, strong) IBOutlet UIButton   *okButton;
@property (nonatomic, strong) IBOutlet UIButton   *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton   *okButton1;
@property (nonatomic, strong) IBOutlet UIButton   *cancelButton1;

+ (SMPopupAlertView*)sharedMessageView:(UIViewController*)viewController;
+ (SMPopupAlertView*)sharedAlertView:(UIViewController*)viewController;
- (void)setTitle:(NSString*)title message:(id)message button:(NSString*)buttonTitle;
- (IBAction)selectClose:(id)sender;
- (IBAction)selectOK:(id)sender;
@end

@interface UIViewController (Popup)
@property (retain, nonatomic) NSNumber* hasBackgoundAlpha;
@property (retain, nonatomic) NSNumber* hasBackgoundTap;

+ (UIFont*)defaultAlertFont;
+ (UIColor*)defaultAlertTextColor;
+ (NSDictionary*)defaultAlertTextAttributes;

- (BOOL)isPopupHidden;
- (void)hideAllPopupViews;
- (void)showPopupView:(UIView*) view animation:(BOOL)animation dismissed:(fDismissCallback)handler;
- (void)showPopupView:(UIView*) view animation:(BOOL)animation background:(BOOL)hasBackground backgroundTap:(BOOL)backgroundTap contentTouch:(BOOL)contentTouch dismissed:(fDismissCallback)handler;
- (void)hidePopupViewWithAnimation:(BOOL)animation dismiss:(NSInteger)returnToDismiss;

- (void)showPopupMessageView:(NSString*)title message:(id)message button:(NSString*)buttonTitle dismissed:(fDismissCallback) handler;
- (void)showPopupAlertView:(NSString*)title message:(id)message button:(NSString*)buttonTitle dismissed:(fDismissCallback) handler;

@end
