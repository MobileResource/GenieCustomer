//
//  RateViewController.h
//  GenieCustomer
//
//  Created by Goldman on 4/29/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPFloatRatingView.h"

@interface RateViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *dismiss_view;
- (IBAction)onClickOK:(id)sender;
- (IBAction)onClickCancel:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *txt_comment;
@property (strong, nonatomic) IBOutlet TPFloatRatingView *frv_rating;
@property (strong, nonatomic) IBOutlet UIButton *btn_ok;
@property (strong, nonatomic) IBOutlet UIButton *btn_cancel;

@property (nonatomic) float current_rating;
@property (strong, nonatomic) NSString* current_comment;
@property (strong, nonatomic) IBOutlet UIView *rate_view;

@property (nonatomic, strong) NSDictionary * dict;
@property (strong, nonatomic) IBOutlet UILabel *lbl_rate;

@end
