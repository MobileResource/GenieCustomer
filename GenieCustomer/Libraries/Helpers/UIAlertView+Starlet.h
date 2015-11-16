//
//  UIAlertView+Starlet.h
//  Starlet
//
//  Created by Lion User on 20/08/2013.
//  Copyright (c) 2013 Starlet. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OKButton        1
#define CancelButton    0

typedef void (^AlertCompleteHandler)(NSInteger buttonIndex);


@interface UIAlertView (Starlet)

+ (void)showMessage:(NSString*)message;
+ (UIAlertView*)showMessage:(NSString*)message delegate:(id)delegate;
+ (UIAlertView*)showMessage:(NSString*)message align:(NSTextAlignment)alignment delegate:(id)delegate;
+ (UIAlertView*)showAlertMessage:(NSString*)message delegate:(id)delegate;
+ (void)showAlertMessage:(NSString*)message withTitle:(NSString*)title button:(NSString*)button button1:(NSString*)button1 complete:(AlertCompleteHandler) handler;
+ (UIAlertView*)showPushMessage:(NSString*)message showView:(BOOL)showView complete:(AlertCompleteHandler) handler;

+ (void)showMessage:(NSString*)message complete:(AlertCompleteHandler) handler;
+ (void)showAlertMessage:(NSString*)message complete:(AlertCompleteHandler) handler;
+ (void)showAlertMessage:(NSString*)message defaultButton:(NSString*)title otherButton:(NSString*)otherTitle complete:(AlertCompleteHandler) handler;
+ (void)showAlertMessage:(NSString*)message buttonTitle:(NSString*)title complete:(AlertCompleteHandler) handler;

@end
