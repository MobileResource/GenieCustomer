//
//  RequestTableViewCell.m
//  GenieCustomer
//
//  Created by Goldman on 4/1/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import "RequestTableViewCell.h"
#import "UIHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UtilitiesHelper.h"
#import "GVUserDefaults+Properties.h"
#import "Constants.h"

@implementation RequestTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell{
    [UIHelper buildCircleImageView:self.img_provider];
    
    [self.img_provider sd_setImageWithURL:[NSURL URLWithString:[UtilitiesHelper getFullImageURL:[self.dict objectForKey:@"pv_image"]]] placeholderImage:[UIImage imageNamed:@"empty_photo.png"]];
    [self.lbl_name setText:[self.dict objectForKey:@"pv_name"]];
    [self.lbl_business_name setText:[self.dict objectForKey:@"pv_business_name"]];
    [self.lbl_amount_from setText:[self.dict objectForKey:@"quote_from"]];
    [self.lbl_amount_to setText:[self.dict objectForKey:@"quote_to"]];
    
    if ([[self.dict objectForKey:@"status"] isEqualToString:@"won"]) {
        self.backgroundColor = [UIHelper colorWithRGBAndAlpha:233.0f g:33.0f b:71.0f alpha:0.3f];
    } else {
        self.backgroundColor = [UIHelper colorWithRGB:255.0f g:255.0f b:255.0f];
    }
    
}

@end
