//
//  ReviewTableViewCell.m
//  GenieCustomer
//
//  Created by Goldman on 4/29/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import "ReviewTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UtilitiesHelper.h"
#import "UIHelper.h"

@implementation ReviewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell{
    
    self.frv_rating.emptySelectedImage = [UIImage imageNamed:@"btn_star_empty.png"];
    self.frv_rating.fullSelectedImage = [UIImage imageNamed:@"btn_star.png"];
    self.frv_rating.contentMode = UIViewContentModeScaleAspectFill;
    self.frv_rating.maxRating = 5;
    self.frv_rating.minRating = 0;
    self.frv_rating.editable = NO;
    self.frv_rating.floatRatings = YES;
    self.frv_rating.halfRatings = NO;
    
    [UIHelper buildCircleImageView:self.img_avatar];
    
    [self.lbl_comment setText:[self.dict objectForKey:@"comment"]];
    [self.lbl_name setText:[self.dict objectForKey:@"cs_name"]];
    
    float rate = [[self.dict objectForKey:@"rate"] floatValue];
    self.frv_rating.rating = rate;
    
    [self.img_avatar sd_setImageWithURL:[NSURL URLWithString:[UtilitiesHelper getFullImageURL:[self.dict objectForKey:@"cs_image"]]] placeholderImage:[UIImage imageNamed:@"empty_photo.png"]];
}

@end
