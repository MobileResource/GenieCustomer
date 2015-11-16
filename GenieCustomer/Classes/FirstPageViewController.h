//
//  FirstPageViewController.h
//  GenieCustomer
//
//  Created by Goldman on 3/27/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstPageViewController : UITableViewController
- (IBAction)onClickMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *onClickRequestsMade;
- (IBAction)onClickRequestMade:(id)sender;

@end
