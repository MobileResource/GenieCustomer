//
//  RequestsViewController.h
//  GenieCustomer
//
//  Created by Goldman on 4/1/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestsViewController : UIViewController
- (IBAction)onClickNext:(id)sender;
- (IBAction)onClickMenu:(id)sender;
- (IBAction)onClickPrev:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *table_requests;

@end
