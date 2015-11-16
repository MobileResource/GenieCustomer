//
//  RequestTableViewCell.h
//  GenieCustomer
//
//  Created by Goldman on 4/1/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *img_provider;
@property (strong, nonatomic) IBOutlet UILabel *lbl_name;
@property (strong, nonatomic) IBOutlet UILabel *lbl_business_name;
@property (strong, nonatomic) IBOutlet UILabel *lbl_amount_from;
@property (strong, nonatomic) IBOutlet UILabel *lbl_amount_to;

@property (nonatomic, strong) NSDictionary * dict;

-(void)configureCell;

@end
