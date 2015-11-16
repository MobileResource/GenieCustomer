//
//  ReviewTableViewCell.h
//  GenieCustomer
//
//  Created by Goldman on 4/29/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPFloatRatingView.h"

@interface ReviewTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *img_avatar;
@property (strong, nonatomic) IBOutlet UILabel *lbl_name;
@property (strong, nonatomic) IBOutlet TPFloatRatingView *frv_rating;
@property (strong, nonatomic) IBOutlet UILabel *lbl_comment;

@property (strong, nonatomic) NSDictionary * dict;

-(void)configureCell;

@end
