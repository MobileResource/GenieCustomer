//
//  ChangePasswordViewController.h
//  GenieProvider
//
//  Created by Goldman on 3/24/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txt_old_pwd;
@property (strong, nonatomic) IBOutlet UITextField *txt_new_pwd;
@property (strong, nonatomic) IBOutlet UITextField *txt_pwd_confirm;
- (IBAction)onClickDone:(id)sender;

@end
