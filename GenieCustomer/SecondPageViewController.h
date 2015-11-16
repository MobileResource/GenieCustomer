//
//  SecondPageViewController.h
//  GenieCustomer
//
//  Created by Goldman on 3/29/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondPageViewController : UITableViewController

@property (nonatomic, strong) NSString * business;
@property (strong, nonatomic) IBOutlet UILabel *lbl_business;

@end
