//
//  ProviderDetailViewController.h
//  GenieCustomer
//
//  Created by Goldman on 4/1/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProviderDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *img_provider;
@property (strong, nonatomic) IBOutlet UILabel *lbl_name;
@property (strong, nonatomic) IBOutlet UIImageView *img_chat;
@property (strong, nonatomic) IBOutlet UILabel *lbl_full_name;
@property (strong, nonatomic) IBOutlet UILabel *lbl_business_address;
@property (strong, nonatomic) IBOutlet UILabel *lbl_business_name;
@property (strong, nonatomic) IBOutlet UILabel *lbl_phone;
@property (strong, nonatomic) IBOutlet UILabel *lbl_postal_code;
@property (strong, nonatomic) IBOutlet UILabel *lbl_website;
@property (strong, nonatomic) IBOutlet UIButton *btn_hire;
@property (strong, nonatomic) IBOutlet UIScrollView *profile_view;
@property (strong, nonatomic) IBOutlet UITableView *tbl_reviews;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment_control;

@property (strong, nonatomic) NSString * rq_id;
@property (nonatomic) BOOL isHired;
@property (nonatomic, strong) NSDictionary * dict;
- (IBAction)onClickHire:(id)sender;
- (IBAction)onSegmentValueChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btn_review;

@end
