//
//  UIHelper.h
//  GameStaker
//
//  Created by Goldman on 2/5/15.
//  Copyright (c) 2015 TS Application Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface UIHelper : NSObject

+(CGColorRef)colorRefWithRGB:(CGFloat)r g:(CGFloat)g b:(CGFloat)b;
+(UIColor*)colorWithRGB:(CGFloat)r g:(CGFloat)g b:(CGFloat)b;

+(CGColorRef)colorRefWithRGBAndAlpha:(CGFloat)r g:(CGFloat)g b:(CGFloat)b alpha:(CGFloat)alpha;
+(UIColor*)colorWithRGBAndAlpha:(CGFloat)r g:(CGFloat)g b:(CGFloat)b alpha:(CGFloat)alpha;

+(void)buildCircleImageView:(UIImageView*)imageView;
+(void)buildRoundedViewWithRadius:(UIView*)view withRadius:(CGFloat)radius;
+(void)buildRoundedViewWithRadiusAndBorderColor:(UIView*)view withRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor*)color;
+(void)showLoader:(NSString *)title forView:(UIView *)view  setMode:(MBProgressHUDMode)mode delegate:(id)vwDelegate;
+(void)hideLoader:(UIView*)forView;
+(void)showPromptAlertforTitle:(NSString *)title withMessage:(NSString *)message forDelegate:(id)deleg;
+(void)dropShadowWithParams:(UIView*)view withColor:(UIColor*)color withOpacity:(CGFloat)opacity withRadius:(CGFloat)radius withOffset:(CGSize)offset;
@end
