//
//  UIAlertView+Starlet.m
//  Starlet
//
//  Created by Lion User on 20/08/2013.
//  Copyright (c) 2013 Starlet. All rights reserved.
//
#import "UIAlertView+Starlet.h"
#import <objc/runtime.h>

#define L(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]


@interface UIAlertViewDelegate : NSObject<UIAlertViewDelegate>

@property (strong, nonatomic) AlertCompleteHandler  completeHandler;

@end

static UIAlertView* sCurrentAlertView = nil;

@implementation UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.completeHandler) {
        self.completeHandler(buttonIndex);
    }
    sCurrentAlertView = nil;
}

@end

@implementation UIAlertView (Starlet)

- (UILabel*)getBodyTextLabel {
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)
        return nil;
    
    return [self valueForKey:@"_bodyTextLabel"];
}

+ (void)showMessage:(NSString*)message {
    if (sCurrentAlertView)
        [sCurrentAlertView dismissWithClickedButtonIndex:CancelButton animated:NO];
    sCurrentAlertView = [UIAlertView showMessage:message align:NSTextAlignmentLeft delegate:nil];
}

+ (UIAlertView*)showMessage:(NSString*)message delegate:(id)delegate {
    if (sCurrentAlertView)
        [sCurrentAlertView dismissWithClickedButtonIndex:CancelButton animated:NO];
    sCurrentAlertView = [UIAlertView showMessage:message align:NSTextAlignmentLeft delegate:delegate];
    return sCurrentAlertView;
}

+ (UIAlertView*)showMessage:(NSString*)message align:(NSTextAlignment)alignment delegate:(id)delegate {
    if (message.length < 1)
        return nil;

    if (sCurrentAlertView)
        [sCurrentAlertView dismissWithClickedButtonIndex:CancelButton animated:NO];
    
    sCurrentAlertView = [[UIAlertView alloc] initWithTitle:@"" message:L(message) delegate:delegate cancelButtonTitle:nil otherButtonTitles:L(@"OK"), nil];
    UILabel* bodyLabel = [sCurrentAlertView getBodyTextLabel];
    if (bodyLabel) {
        bodyLabel.textAlignment = alignment;
        bodyLabel.font = [UIFont systemFontOfSize:14];
    }
    [sCurrentAlertView show];
    return sCurrentAlertView;
}

+ (UIAlertView*)showAlertMessage:(NSString*)message delegate:(id)delegate {
    if (message.length < 1)
        return nil;

    if (sCurrentAlertView)
        [sCurrentAlertView dismissWithClickedButtonIndex:CancelButton animated:NO];

    sCurrentAlertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:delegate cancelButtonTitle:L(@"No") otherButtonTitles:L(@"Yes"), nil];
    UILabel* bodyLabel = [sCurrentAlertView getBodyTextLabel];
    if (bodyLabel) {
        bodyLabel.textAlignment = NSTextAlignmentLeft;
        bodyLabel.font = [UIFont systemFontOfSize:14];
    }
    [sCurrentAlertView show];
    return sCurrentAlertView;
}

+ (void)showMessage:(NSString*)message complete:(AlertCompleteHandler) handler {
    static UIAlertViewDelegate* sAlertDelegate = nil;
    if (sAlertDelegate == nil)
        sAlertDelegate = [UIAlertViewDelegate new];
    sAlertDelegate.completeHandler = handler;

    if (sCurrentAlertView)
        [sCurrentAlertView dismissWithClickedButtonIndex:CancelButton animated:NO];

    sCurrentAlertView = [[UIAlertView alloc] initWithTitle:@"" message:L(message) delegate:sAlertDelegate cancelButtonTitle:nil otherButtonTitles:L(@"OK"), nil];
    UILabel* bodyLabel = [sCurrentAlertView getBodyTextLabel];
    if (bodyLabel) {
        bodyLabel.textAlignment = NSTextAlignmentLeft;
        bodyLabel.font = [UIFont systemFontOfSize:14];
    }
    [sCurrentAlertView show];
}

+ (void)showAlertMessage:(NSString*)message complete:(AlertCompleteHandler) handler {
    static UIAlertViewDelegate* sAlertDelegate = nil;
    if (sAlertDelegate == nil)
        sAlertDelegate = [UIAlertViewDelegate new];
    sAlertDelegate.completeHandler = handler;
    
    if (sCurrentAlertView)
        [sCurrentAlertView dismissWithClickedButtonIndex:CancelButton animated:NO];
    
    sCurrentAlertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:sAlertDelegate cancelButtonTitle:L(@"No") otherButtonTitles:L(@"Yes"), nil];
    UILabel* bodyLabel = [sCurrentAlertView getBodyTextLabel];
    if (bodyLabel) {
        bodyLabel.textAlignment = NSTextAlignmentLeft;
        bodyLabel.font = [UIFont systemFontOfSize:14];
    }
    [sCurrentAlertView show];
}

+ (UIView*)createCustomBodyLabel:(NSString*)title message:(NSAttributedString*)message {
    UILabel* bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 20)];
    bodyLabel.numberOfLines = 0;
    NSMutableAttributedString* bodyString = [[NSMutableAttributedString alloc] initWithString:[title stringByAppendingString:@"\n\n"] attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:15]}];
    [bodyString appendAttributedString:message];
    bodyLabel.attributedText = bodyString;
    CGSize bodySize = [bodyLabel sizeThatFits:CGSizeMake(260, 9999)];
    
    UIView* bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, bodySize.height + 20)];
    bodyView.backgroundColor = [UIColor clearColor];

    CGRect frame = bodyLabel.frame;
    frame.origin.x = 10;
    frame.origin.y = 10;
    frame.size = bodySize;
    bodyLabel.frame = frame;

    [bodyView addSubview:bodyLabel];
    return bodyView;
}

+ (void)showAlertMessage:(NSString*)message buttonTitle:(NSString*)title complete:(AlertCompleteHandler) handler {
    [self showAlertMessage:message withTitle:@"" button:title button1:nil complete:handler];
}
+ (void)showAlertMessage:(NSString*)message defaultButton:(NSString*)title otherButton:(NSString*)otherTitle complete:(AlertCompleteHandler) handler {
    [self showAlertMessage:message withTitle:@"" button:title button1:otherTitle complete:handler];
}

+ (void)showAlertMessage:(NSString*)message withTitle:(NSString*)title button:(NSString*)button button1:(NSString*)button1 complete:(AlertCompleteHandler) handler {
    static UIAlertViewDelegate* sAlertDelegate = nil;
    if (sAlertDelegate == nil)
        sAlertDelegate = [UIAlertViewDelegate new];
    sAlertDelegate.completeHandler = handler;
    
    if (sCurrentAlertView)
        [sCurrentAlertView dismissWithClickedButtonIndex:CancelButton animated:NO];
    
    sCurrentAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:sAlertDelegate cancelButtonTitle:(button1 ? button1 : L(@"NO")) otherButtonTitles:(button ? button : L(@"YES")), nil];
    UILabel* bodyLabel = [sCurrentAlertView getBodyTextLabel];
    if (bodyLabel) {
        bodyLabel.textAlignment = NSTextAlignmentLeft;
        bodyLabel.font = [UIFont systemFontOfSize:14];
    }
    [sCurrentAlertView show];
}


+ (UIAlertView*)showPushMessage:(NSString*)message showView:(BOOL)showView complete:(AlertCompleteHandler) handler {
    static UIAlertViewDelegate* sAlertDelegate = nil;
    if (sAlertDelegate == nil)
        sAlertDelegate = [UIAlertViewDelegate new];
    sAlertDelegate.completeHandler = handler;

    if (sCurrentAlertView)
        [sCurrentAlertView dismissWithClickedButtonIndex:CancelButton animated:NO];
    
    NSString* cancel = nil;
    if (showView)
        cancel = L(@"Cancel");

    sCurrentAlertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:sAlertDelegate cancelButtonTitle:cancel otherButtonTitles:L(@"View"), nil];
    UILabel* bodyLabel = [sCurrentAlertView getBodyTextLabel];
    if (bodyLabel) {
        bodyLabel.textAlignment = NSTextAlignmentLeft;
        bodyLabel.font = [UIFont systemFontOfSize:14];
    }
    [sCurrentAlertView show];
    
    return sCurrentAlertView;
}

@end
