//
//  UIHelper.m
//  GameStaker
//
//  Created by Goldman on 2/5/15.
//  Copyright (c) 2015 TS Application Ltd. All rights reserved.
//

#import "UIHelper.h"


@implementation UIHelper

+(CGColorRef)colorRefWithRGB:(CGFloat)r g:(CGFloat)g b:(CGFloat)b{
    UIColor * returnColor = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f];
    return returnColor.CGColor;
}

+(UIColor*)colorWithRGB:(CGFloat)r g:(CGFloat)g b:(CGFloat)b{
    UIColor * returnColor = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f];
    return returnColor;
}

+(CGColorRef)colorRefWithRGBAndAlpha:(CGFloat)r g:(CGFloat)g b:(CGFloat)b alpha:(CGFloat)alpha{
    UIColor * returnColor = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:alpha];
    return returnColor.CGColor;
}

+(UIColor*)colorWithRGBAndAlpha:(CGFloat)r g:(CGFloat)g b:(CGFloat)b alpha:(CGFloat)alpha{
    UIColor * returnColor = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:alpha];
    return returnColor;
}


+(void)buildCircleImageView:(UIImageView*)imageView{
    imageView.layer.cornerRadius = imageView.frame.size.width / 2.0f;
    imageView.clipsToBounds = YES;
}

+(void)buildRoundedViewWithRadius:(UIView*)view withRadius:(CGFloat)radius{
    view.layer.cornerRadius = radius;
    view.clipsToBounds = YES;
}

+(void)buildRoundedViewWithRadiusAndBorderColor:(UIView*)view withRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor*)color{
    view.layer.cornerRadius = radius;
    view.clipsToBounds = YES;
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
}

+(void)showPromptAlertforTitle:(NSString *)title withMessage:(NSString *)message forDelegate:(id)deleg
{
    
    
    UIAlertView  *alertBlock = [[UIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:deleg
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil];
    
    [alertBlock show];
    
    
}

+(void)showLoader:(NSString *)title forView:(UIView *)view  setMode:(MBProgressHUDMode)mode delegate:(id)vwDelegate
{
    if(view == nil) return;
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [progressHUD setMode:mode];
    [progressHUD setDimBackground:YES];
    [progressHUD setLabelText:title];
    [progressHUD setMinShowTime:1.0];
}

+(void)hideLoader:(UIView *)forView
{
    if (forView == nil) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:forView animated:YES];
    });
}

+(void)dropShadowWithParams:(UIView*)view withColor:(UIColor*)color withOpacity:(CGFloat)opacity withRadius:(CGFloat)radius withOffset:(CGSize)offset{
    view.layer.shadowColor = [color CGColor];
    view.layer.shadowOpacity = opacity;
    view.layer.shadowRadius = radius;
    view.layer.shadowOffset = offset;
}

@end
