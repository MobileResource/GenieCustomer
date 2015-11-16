//
//  RequestHeaderView.m
//  GenieCustomer
//
//  Created by Goldman on 4/1/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import "RequestHeaderView.h"

@implementation RequestHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"RequestHeaderView" owner:self options:nil];
        [self.contentView addSubview:views[0]];
        CGRect frame = self.contentView.frame;
        frame.size.width = [UIScreen mainScreen].bounds.size.width;
        self.contentView.frame = frame;
        UIView *view = views[0];
        view.frame = self.contentView.bounds;
        
        //self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
